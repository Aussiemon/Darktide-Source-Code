-- chunkname: @dialogues/generated/enemy_vo.lua

return function ()
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "chaos_armored_infected_alerted_idle",
		response = "chaos_armored_infected_alerted_idle",
		wwise_route = 20,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_armored_infected",
			},
			{
				"user_memory",
				"chaos_armored_infected_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"chaos_armored_infected_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"chaos_armored_infected_alerted_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"chaos_armored_infected_alerted_idle",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "chaos_armored_infected_assault",
		response = "chaos_armored_infected_assault",
		wwise_route = 43,
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
				"assault",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_armored_infected",
			},
			{
				"user_memory",
				"chaos_armored_infected_assault",
				OP.TIMEDIFF,
				OP.GT,
				8,
			},
			{
				"faction_memory",
				"chaos_armored_infected_assault",
				OP.TIMEDIFF,
				OP.GT,
				4,
			},
		},
		on_done = {
			{
				"user_memory",
				"chaos_armored_infected_assault",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"chaos_armored_infected_assault",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "chaos_armored_infected_melee_idle",
		response = "chaos_armored_infected_melee_idle",
		wwise_route = 20,
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
				"melee_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_armored_infected",
			},
			{
				"user_memory",
				"chaos_armored_infected_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"chaos_armored_infected_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"chaos_armored_infected_melee_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"chaos_armored_infected_melee_idle",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "chaos_daemonhost_aggro",
		response = "chaos_daemonhost_aggro",
		wwise_route = 15,
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
				"chaos_daemonhost_aggro",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost",
			},
			{
				"user_memory",
				"enemy_memory_chaos_daemonhost_aggro",
				OP.TIMEDIFF,
				OP.GT,
				0,
			},
			{
				"faction_memory",
				"faction_memory_chaos_daemonhost_aggro",
				OP.TIMEDIFF,
				OP.GT,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_chaos_daemonhost_aggro",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_chaos_daemonhost_aggro",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "chaos_daemonhost_death_long",
		response = "chaos_daemonhost_death_long",
		wwise_route = 15,
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
				"chaos_daemonhost_death_long",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost",
			},
			{
				"user_memory",
				"enemy_memory_daemonhost_death_long",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_daemonhost_death_long",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_daemonhost_death_long",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_daemonhost_death_long",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "chaos_daemonhost_mantra_high",
		response = "chaos_daemonhost_mantra_high",
		wwise_route = 15,
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
				"chaos_daemonhost_mantra_high",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost",
			},
			{
				"user_memory",
				"enemy_memory_daemonhost_mantra_high",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
			{
				"faction_memory",
				"faction_memory_daemonhost_mantra_high",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_daemonhost_mantra_high",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_daemonhost_mantra_high",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "chaos_daemonhost_mantra_low",
		response = "chaos_daemonhost_mantra_low",
		wwise_route = 15,
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
				"chaos_daemonhost_mantra_low",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost",
			},
			{
				"user_memory",
				"enemy_memory_daemonhost_mantra_low",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_daemonhost_mantra_low",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "chaos_daemonhost_mantra_medium",
		response = "chaos_daemonhost_mantra_medium",
		wwise_route = 15,
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
				"chaos_daemonhost_mantra_medium",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost",
			},
			{
				"user_memory",
				"enemy_memory_daemonhost_mantra_medium",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_daemonhost_mantra_medium",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "chaos_daemonhost_warp_grab",
		response = "chaos_daemonhost_warp_grab",
		wwise_route = 32,
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
				"chaos_daemonhost_warp_grab",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost",
			},
			{
				"user_memory",
				"enemy_memory_daemonhost_warp_grab",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_daemonhost_warp_grab",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_daemonhost_warp_grab",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_daemonhost_warp_grab",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "chaos_newly_infected_alerted_idle",
		response = "chaos_newly_infected_alerted_idle",
		wwise_route = 20,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_newly_infected",
			},
			{
				"user_memory",
				"enemy_memory_ni_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_ni_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_ni_alerted_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_ni_alerted_idle",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "chaos_newly_infected_assault",
		response = "chaos_newly_infected_assault",
		wwise_route = 43,
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
				"assault",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_newly_infected",
			},
			{
				"user_memory",
				"enemy_memory_ni_assault",
				OP.TIMEDIFF,
				OP.GT,
				8,
			},
			{
				"faction_memory",
				"faction_memory_ni_assault",
				OP.TIMEDIFF,
				OP.GT,
				4,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_ni_assault",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_ni_assault",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "chaos_newly_infected_melee_idle",
		response = "chaos_newly_infected_melee_idle",
		wwise_route = 20,
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
				"melee_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_newly_infected",
			},
			{
				"user_memory",
				"enemy_memory_ni_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_ni_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_ni_melee_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_ni_melee_idle",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "chaos_ogryn_bulwark_alerted_idle",
		response = "chaos_ogryn_bulwark_alerted_idle",
		wwise_route = 9,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_bulwark",
			},
			{
				"user_memory",
				"enemy_memory_chaos_ogryn_bulwark_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_chaos_ogryn_bulwark_alerted_idle",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "chaos_ogryn_bulwark_assault",
		response = "chaos_ogryn_bulwark_assault",
		wwise_route = 9,
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
				"assault",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_bulwark",
			},
			{
				"user_memory",
				"chaos_ogryn_bulwark_assault",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_chaos_ogryn_bulwark_assault",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"chaos_ogryn_bulwark_assault",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_chaos_ogryn_bulwark_assault",
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
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "chaos_ogryn_executor_alerted_idle",
		response = "chaos_ogryn_executor_alerted_idle",
		wwise_route = 6,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_executor",
			},
			{
				"user_memory",
				"enemy_memory_chaos_ogryn_executor_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
			{
				"faction_memory",
				"",
				OP.TIMEDIFF,
				OP.GT,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_chaos_ogryn_executor_alerted_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "chaos_ogryn_executor_assault",
		response = "chaos_ogryn_executor_assault",
		wwise_route = 6,
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
				"assault",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_executor",
			},
			{
				"user_memory",
				"chaos_ogryn_executor_assault",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_chaos_ogryn_executor_assault",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"chaos_ogryn_executor_assault",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_chaos_ogryn_executor_assault",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "chaos_ogryn_executor_no_damage",
		response = "chaos_ogryn_executor_no_damage",
		wwise_route = 6,
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
				"no_damage_taunt",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_executor",
			},
			{
				"user_memory",
				"enemy_memory_no_damage_taunt",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
			{
				"faction_memory",
				"faction_memory_no_damage_taunt",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_no_damage_taunt",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_no_damage_taunt",
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
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "chaos_ogryn_heavy_gunner_alerted_idle",
		response = "chaos_ogryn_heavy_gunner_alerted_idle",
		wwise_route = 8,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_gunner",
			},
			{
				"user_memory",
				"enemy_memory_ogryn_gunner_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				6,
			},
			{
				"faction_memory",
				"faction_memory_ogryn_gunner_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				3,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_ogryn_gunner_alerted_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_ogryn_gunner_alerted_idle",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "chaos_ogryn_heavy_gunner_shooting",
		response = "chaos_ogryn_heavy_gunner_shooting",
		wwise_route = 8,
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
				"start_shooting",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_gunner",
			},
			{
				"user_memory",
				"enemy_memory_ogryn_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				3,
			},
			{
				"faction_memory",
				"faction_memory_ogryn_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_ogryn_start_shooting",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_ogryn_start_shooting",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "cultist_captain_long_death",
		response = "cultist_captain_long_death",
		wwise_route = 55,
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
				"long_death",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_captain",
			},
			{
				"user_memory",
				"enemy_memory_cultist_captain_long_death",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_captain_long_death",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "cultist_captain_reinforcements",
		response = "cultist_captain_reinforcements",
		wwise_route = 7,
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
				"reinforcements",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_captain",
			},
			{
				"user_memory",
				"enemy_memory_cultist_captain_reinforcements",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"enemy_memory_cultist_captain_taunt_combat",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_captain_reinforcements",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "cultist_captain_taunt",
		response = "cultist_captain_taunt",
		wwise_route = 55,
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
				"cultist_captain",
			},
			{
				"user_memory",
				"enemy_memory_cultist_captain_taunt",
				OP.GTEQ,
				OP.GT,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_captain_taunt",
				OP.ADD,
				"1",
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default_class",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "cultist_captain_taunt_combat",
		response = "cultist_captain_taunt_combat",
		wwise_route = 7,
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
				"taunt_combat",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_captain",
			},
			{
				"user_memory",
				"enemy_memory_cultist_captain_taunt_combat",
				OP.TIMEDIFF,
				OP.GT,
				35,
			},
			{
				"user_memory",
				"enemy_memory_cultist_captain_taunt",
				OP.GT,
				OP.GT,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_captain_taunt_combat",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "cultist_flamer_spawned",
		response = "cultist_flamer_spawned",
		wwise_route = 23,
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
				"spawned",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_flamer",
			},
			{
				"faction_memory",
				"faction_memory_cultist_flamer_spawned",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_cultist_flamer_spawned",
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
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "cultist_flamer_start_shooting",
		response = "cultist_flamer_start_shooting",
		wwise_route = 23,
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
				"start_shooting",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_flamer",
			},
			{
				"user_memory",
				"enemy_memory_cf_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				4,
			},
			{
				"faction_memory",
				"faction_memory_cf_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cf_start_shooting",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_cf_start_shooting",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1.5,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "cultist_grenadier_skulking",
		response = "cultist_grenadier_skulking",
		wwise_route = 25,
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
				"skulking",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_grenadier",
			},
			{
				"user_memory",
				"enemy_memory_cultist_grenadier_skulking",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
			{
				"faction_memory",
				"faction_enemy_memory_cultist_grenadier_skulking",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_grenadier_skulking",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_enemy_memory_cultist_grenadier_skulking",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "cultist_grenadier_spawned",
		response = "cultist_grenadier_spawned",
		wwise_route = 25,
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
				"spawned",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_grenadier",
			},
			{
				"faction_memory",
				"faction_memory_cultist_grenadier_spawned",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_cultist_grenadier_spawned",
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
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "cultist_grenadier_throwing_grenade",
		response = "cultist_grenadier_throwing_grenade",
		wwise_route = 25,
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
				"throwing_grenade",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_grenadier",
			},
			{
				"user_memory",
				"cultist_grenadier_throwing_grenade",
				OP.TIMEDIFF,
				OP.GT,
				9,
			},
		},
		on_done = {
			{
				"user_memory",
				"cultist_grenadier_throwing_grenade",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "cultist_gunner_friendly_fire",
		response = "cultist_gunner_friendly_fire",
		wwise_route = 26,
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
				"friendly_fire",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_gunner",
			},
			{
				"user_memory",
				"enemy_memory_cultist_gunner_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
			{
				"faction_memory",
				"faction_memory_cultist_gunner_friendly_fire",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_gunner_friendly_fire",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_cultist_gunner_friendly_fire",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "cultist_gunner_reloading",
		response = "cultist_gunner_reloading",
		wwise_route = 26,
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
				"reloading",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_gunner",
			},
			{
				"user_memory",
				"enemy_memory_cultist_gunner_reloading",
				OP.TIMEDIFF,
				OP.GT,
				3,
			},
			{
				"faction_memory",
				"faction_memory_cultist_gunner_reloading",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_gunner_reloading",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_cultist_gunner_reloading",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "cultist_gunner_start_shooting",
		response = "cultist_gunner_start_shooting",
		wwise_route = 26,
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
				"start_shooting",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_gunner",
			},
			{
				"user_memory",
				"memory_cultist_gunner_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				3,
			},
			{
				"faction_memory",
				"faction_memory_cultist_gunner_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"memory_cultist_gunner_start_shooting",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_cultist_gunner_start_shooting",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "cultist_melee_fighter_alerted_idle",
		response = "cultist_melee_fighter_alerted_idle",
		wwise_route = 34,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_melee",
			},
			{
				"user_memory",
				"cultist_melee_fighter_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_cultist_melee_fighter_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"cultist_melee_fighter_alerted_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_cultist_melee_fighter_alerted_idle",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "cultist_melee_fighter_assault",
		response = "cultist_melee_fighter_assault",
		wwise_route = 34,
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
				"assault",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_melee",
			},
			{
				"user_memory",
				"cultist_melee_fighter_assault",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_cultist_melee_fighter_assault",
				OP.TIMEDIFF,
				OP.GT,
				4,
			},
		},
		on_done = {
			{
				"user_memory",
				"cultist_melee_fighter_assault",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_cultist_melee_fighter_assault",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "cultist_melee_fighter_long_death",
		response = "cultist_melee_fighter_long_death",
		wwise_route = 34,
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
				"long_death",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_melee",
			},
			{
				"user_memory",
				"enemy_memory_long_death",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
			{
				"faction_memory",
				"faction_memory_long_death",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_long_death",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_long_death",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "cultist_melee_fighter_melee_idle",
		response = "cultist_melee_fighter_melee_idle",
		wwise_route = 34,
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
				"melee_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_melee",
			},
			{
				"user_memory",
				"cultist_melee_fighter_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
			{
				"faction_memory",
				"faction_memory_cultist_melee_fighter_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"cultist_melee_fighter_melee_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_cultist_melee_fighter_melee_idle",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "cultist_rusher_switch_to_melee",
		response = "cultist_rusher_switch_to_melee",
		wwise_route = 33,
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
				"switch_to_melee",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_assault",
			},
			{
				"user_memory",
				"cultist_rusher_switch_to_melee",
				OP.TIMEDIFF,
				OP.GT,
				8,
			},
			{
				"faction_memory",
				"faction_memory_cultist_rusher_switch_to_melee",
				OP.TIMEDIFF,
				OP.GT,
				4,
			},
		},
		on_done = {
			{
				"user_memory",
				"cultist_rusher_switch_to_melee",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_cultist_rusher_switch_to_melee",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "cultist_rusher_take_cover",
		response = "cultist_rusher_take_cover",
		wwise_route = 33,
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
				"take_cover",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_assault",
			},
			{
				"user_memory",
				"cultist_assault_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
			{
				"faction_memory",
				"faction_memory_cultist_assault_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				8,
			},
		},
		on_done = {
			{
				"user_memory",
				"cultist_assault_take_cover",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_cultist_assault_take_cover",
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
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "cultist_shocktrooper_alerted_idle",
		response = "cultist_shocktrooper_alerted_idle",
		wwise_route = 27,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_shocktrooper",
			},
			{
				"user_memory",
				"enemy_memory_cultist_shocktrooper",
				OP.TIMEDIFF,
				OP.GT,
				6,
			},
			{
				"faction_memory",
				"faction_memory_cultist_shocktrooper",
				OP.TIMEDIFF,
				OP.GT,
				3,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_shocktrooper",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_cultist_shocktrooper",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "cultist_shocktrooper_shooting",
		response = "cultist_shocktrooper_shooting",
		wwise_route = 27,
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
				"start_shooting",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_shocktrooper",
			},
			{
				"user_memory",
				"enemy_memory_cultist_shocktrooper_shooting",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
			{
				"faction_memory",
				"faction_memory_cultist_shocktrooper_shooting",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_cultist_shocktrooper_shooting",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_cultist_shocktrooper_shooting",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "enemy_cultist_berzerker_assault",
		response = "enemy_cultist_berzerker_assault",
		wwise_route = 46,
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
				"assault",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_berzerker",
			},
			{
				"user_memory",
				"cultist_berzerker_assault",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_cultist_berzerker_assault",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"cultist_berzerker_assault",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_traitor_berzerker_assault",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "enemy_cultist_rusher_alerted_idle",
		response = "enemy_cultist_rusher_alerted_idle",
		wwise_route = 33,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_assault",
			},
			{
				"user_memory",
				"cultist_assault_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_cultist_assault_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"cultist_assault_alerted_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_cultist_assault_alerted_idle",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "enemy_cultist_rusher_assault",
		response = "enemy_cultist_rusher_assault",
		wwise_route = 33,
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
				"assault",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_assault",
			},
			{
				"user_memory",
				"cultist_rusher_assault",
				OP.TIMEDIFF,
				OP.GT,
				8,
			},
			{
				"faction_memory",
				"faction_memory_rusher_assault",
				OP.TIMEDIFF,
				OP.GT,
				4,
			},
		},
		on_done = {
			{
				"user_memory",
				"cultist_rusher_assault",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_rusher_assault",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "ranged_idle_player_low_on_health",
		response = "ranged_idle_player_low_on_health",
		wwise_route = 2,
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
					"response_for_ogryn_critical_health",
					"response_for_psyker_critical_health",
					"response_for_veteran_critical_health",
					"response_for_zealot_critical_health",
				},
			},
			{
				"user_memory",
				"ranged_idle_player_low_on_health",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"ranged_idle_player_low_on_health",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "ranged_idle_player_out_of_ammo",
		response = "ranged_idle_player_out_of_ammo",
		wwise_route = 2,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"ranged_idle_player_out_of_ammo",
			},
			{
				"user_memory",
				"ranged_idle_player_out_of_ammo",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"ranged_idle_player_out_of_ammo",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "renegade_captain_long_death",
		response = "renegade_captain_long_death",
		wwise_route = 7,
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
				"long_death",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_captain",
			},
			{
				"user_memory",
				"enemy_memory_renegade_captain_long_death",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_renegade_captain_long_death",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "renegade_captain_reinforcements",
		response = "renegade_captain_reinforcements",
		wwise_route = 7,
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
				"reinforcements",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_captain",
			},
			{
				"user_memory",
				"enemy_memory_renegade_captain_reinforcements",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"enemy_memory_renegade_captain_taunt_combat",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_renegade_captain_reinforcements",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "renegade_captain_taunt",
		response = "renegade_captain_taunt",
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
				"taunt",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_captain",
			},
			{
				"user_memory",
				"enemy_memory_renegade_captain_taunt",
				OP.GTEQ,
				OP.GT,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_renegade_captain_taunt",
				OP.ADD,
				"1",
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default_class",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.5,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "renegade_captain_taunt_combat",
		response = "renegade_captain_taunt_combat",
		wwise_route = 7,
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
				"taunt_combat",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_captain",
			},
			{
				"user_memory",
				"enemy_memory_renegade_captain_taunt_combat",
				OP.TIMEDIFF,
				OP.GT,
				35,
			},
			{
				"user_memory",
				"enemy_memory_renegade_captain_taunt",
				OP.GT,
				OP.GT,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_renegade_captain_taunt_combat",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "renegade_grenadier_skulking",
		response = "renegade_grenadier_skulking",
		wwise_route = 13,
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
				"skulking",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_grenadier",
			},
			{
				"user_memory",
				"enemy_memory_renegade_grenadier_skulking",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
			{
				"faction_memory",
				"faction_memory_renegade_grenadier_skulking",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_renegade_grenadier_skulking",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_renegade_grenadier_skulking",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "traitor_berzerker_assault",
		response = "traitor_berzerker_assault",
		wwise_route = 48,
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
				"assault",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_berzerker",
			},
			{
				"user_memory",
				"traitor_berzerker_assault",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_traitor_berzerker_assault",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_berzerker_assault",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_enforcer_executor_alerted_idle",
		response = "traitor_enforcer_executor_alerted_idle",
		wwise_route = 10,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_executor",
			},
			{
				"user_memory",
				"enemy_memory_traitor_enforcer_executor_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
			{
				"faction_memory",
				"",
				OP.TIMEDIFF,
				OP.GT,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_traitor_enforcer_executor_alerted_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "traitor_enforcer_executor_executor_assault",
		response = "traitor_enforcer_executor_executor_assault",
		wwise_route = 10,
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
				"assault",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_executor",
			},
			{
				"user_memory",
				"renegade_executor_assault",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_renegade_executor_assault",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"renegade_executor_assault",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_renegade_executor_assault",
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
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_enforcer_executor_executor_melee_idle",
		response = "traitor_enforcer_executor_executor_melee_idle",
		wwise_route = 10,
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
				"melee_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_executor",
			},
			{
				"user_memory",
				"melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
		},
		on_done = {
			{
				"user_memory",
				"melee_idle",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_enforcer_executor_special_attack",
		response = "traitor_enforcer_executor_special_attack",
		wwise_route = 10,
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
				"special_attack",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_executor",
			},
			{
				"user_memory",
				"special_attack",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"special_attack",
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
		database = "enemy_vo",
		name = "traitor_grenadier_spawned",
		response = "traitor_grenadier_spawned",
		wwise_route = 13,
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
				"spawned",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_grenadier",
			},
			{
				"faction_memory",
				"faction_memory_traitor_grenadier_spawned",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_traitor_grenadier_spawned",
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
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_grenadier_throwing_grenade",
		response = "traitor_grenadier_throwing_grenade",
		wwise_route = 13,
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
				"throwing_grenade",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_grenadier",
			},
			{
				"user_memory",
				"throwing_grenade",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"throwing_grenade",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "traitor_guard_flamer_spawned",
		response = "traitor_guard_flamer_spawned",
		wwise_route = 44,
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
				"spawned",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_flamer",
			},
			{
				"faction_memory",
				"faction_memory_traitor_flamer_spawned",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_traitor_flamer_spawned",
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
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "traitor_guard_flamer_start_shooting",
		response = "traitor_guard_flamer_start_shooting",
		wwise_route = 44,
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
				"start_shooting",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_flamer",
			},
			{
				"faction_memory",
				"faction_memory_traitor_flamer_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
			{
				"user_memory",
				"enemy_memory_traitor_flamer_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				4,
			},
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_traitor_flamer_start_shooting",
				OP.TIMESET,
			},
			{
				"user_memory",
				"enemy_memory_traitor_flamer_start_shooting",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1.5,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_guard_rifleman_alerted_idle",
		response = "traitor_guard_rifleman_alerted_idle",
		wwise_route = 18,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_rifleman",
			},
			{
				"user_memory",
				"traitor_guard_rifleman_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_guard_rifleman_alerted_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_alerted_idle",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_guard_rifleman_ranged_idle",
		response = "traitor_guard_rifleman_ranged_idle",
		wwise_route = 18,
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
				"ranged_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_rifleman",
			},
			{
				"user_memory",
				"traitor_guard_rifleman_ranged_idle",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_ranged_idle",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_guard_rifleman_ranged_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_ranged_idle",
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
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_guard_rifleman_ranged_idle_player_low_on_ammo",
		response = "traitor_guard_rifleman_ranged_idle_player_low_on_ammo",
		wwise_route = 18,
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
				OP.EQ,
				"reload_failed_out_of_ammo",
			},
			{
				"user_memory",
				"last_replied",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_replied",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_guard_rifleman_take_cover",
		response = "traitor_guard_rifleman_take_cover",
		wwise_route = 18,
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
				"take_cover",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_rifleman",
			},
			{
				"user_memory",
				"traitor_guard_rifleman_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				8,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_guard_rifleman_take_cover",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_take_cover",
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
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_guard_rifleman_take_position",
		response = "traitor_guard_rifleman_take_position",
		wwise_route = 18,
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
				"take_position",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_rifleman",
			},
			{
				"user_memory",
				"traitor_guard_rifleman_take_position",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_take_position",
				OP.TIMEDIFF,
				OP.GT,
				8,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_guard_rifleman_take_position",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_rifleman_take_position",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_guard_smg_rusher_alerted_idle",
		response = "traitor_guard_smg_rusher_alerted_idle",
		wwise_route = 18,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_assault",
			},
			{
				"user_memory",
				"traitor_guard_smg_rusher_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_smg_rusher_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_guard_smg_rusher_alerted_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_smg_rusher_alerted_idle",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_guard_smg_rusher_ranged_idle",
		response = "traitor_guard_smg_rusher_ranged_idle",
		wwise_route = 18,
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
				"ranged_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_assault",
			},
			{
				"user_memory",
				"traitor_guard_smg_rusher_ranged_idle",
				OP.TIMEDIFF,
				OP.GT,
				8,
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_smg_rusher_ranged_idle",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_guard_smg_rusher_ranged_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_guard_smg_rusher_ranged_idle",
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
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_guard_smg_rusher_ranged_idle_player_low_on_ammo",
		response = "traitor_guard_smg_rusher_ranged_idle_player_low_on_ammo",
		wwise_route = 18,
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
				OP.EQ,
				"reload_failed_out_of_ammo",
			},
			{
				"user_memory",
				"last_replied",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_replied",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_guard_smg_rusher_ranged_idle_player_low_on_health",
		response = "traitor_guard_smg_rusher_ranged_idle_player_low_on_health",
		wwise_route = 18,
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
				OP.EQ,
				"critical_health",
			},
			{
				"user_memory",
				"last_replied",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_replied",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_guard_smg_rusher_take_cover",
		response = "traitor_guard_smg_rusher_take_cover",
		wwise_route = 18,
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
				"take_cover",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_assault",
			},
			{
				"user_memory",
				"enemy_memory_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_take_cover",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_take_cover",
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
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_guard_smg_rusher_take_position",
		response = "traitor_guard_smg_rusher_take_position",
		wwise_route = 18,
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
				"take_position",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_assault",
			},
			{
				"user_memory",
				"enemy_memory_take_position",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_take_position",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_take_position",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_take_position",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_gunner_alerted_idle",
		response = "traitor_gunner_alerted_idle",
		wwise_route = 11,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_gunner",
			},
			{
				"user_memory",
				"enemy_memory_traitor_gunner_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				6,
			},
			{
				"faction_memory",
				"faction_memory_traitor_gunner_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				3,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_traitor_gunner_alerted_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_gunner_alerted_idle",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_gunner_ranged_idle",
		response = "traitor_gunner_ranged_idle",
		wwise_route = 11,
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
				"ranged_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_gunner",
			},
			{
				"user_memory",
				"enemy_memory_traitor_gunner_ranged_idle",
				OP.TIMEDIFF,
				OP.GT,
				40,
			},
			{
				"faction_memory",
				"faction_memory_traitor_gunner_ranged_idle",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_traitor_gunner_ranged_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_gunner_ranged_idle",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_gunner_ranged_idle_player_low_on_ammo",
		response = "traitor_gunner_ranged_idle_player_low_on_ammo",
		wwise_route = 18,
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
				OP.EQ,
				"reload_failed_out_of_ammo",
			},
			{
				"user_memory",
				"last_replied",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_replied",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_gunner_ranged_idle_player_low_on_health",
		response = "traitor_gunner_ranged_idle_player_low_on_health",
		wwise_route = 18,
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
				OP.EQ,
				"critical_health",
			},
			{
				"user_memory",
				"last_replied",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_replied",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_gunner_start_shooting",
		response = "traitor_gunner_start_shooting",
		wwise_route = 11,
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
				"start_shooting",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_gunner",
			},
			{
				"user_memory",
				"enemy_memory_traitor_gunner_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				3,
			},
			{
				"faction_memory",
				"faction_memory_traitor_gunner_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_traitor_gunner_start_shooting",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_gunner_start_shooting",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_gunner_take_cover",
		response = "traitor_gunner_take_cover",
		wwise_route = 11,
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
				"take_cover",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_gunner",
			},
			{
				"user_memory",
				"enemy_memory_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
			{
				"faction_memory",
				"faction_memory_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_take_cover",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_take_cover",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_gunner_take_position",
		response = "traitor_gunner_take_position",
		wwise_route = 11,
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
				"take_position",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_gunner",
			},
			{
				"user_memory",
				"enemy_memory_take_position",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
			{
				"faction_memory",
				"faction_memory_take_position",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_take_position",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_take_position",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "traitor_netgunner_assault",
		response = "traitor_netgunner_assault",
		wwise_route = 14,
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
				"assault",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_netgunner",
			},
			{
				"faction_memory",
				"faction_traitor_netgunner_assault",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
			{
				"user_memory",
				"user_traitor_netgunner_assault",
				OP.TIMEDIFF,
				OP.GT,
				3,
			},
		},
		on_done = {
			{
				"faction_memory",
				"faction_traitor_netgunner_assault",
				OP.TIMESET,
			},
			{
				"user_memory",
				"user_traitor_netgunner_assault",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "traitor_netgunner_catching_net",
		response = "traitor_netgunner_catching_net",
		wwise_route = 14,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"catching_net",
			},
			{
				"user_memory",
				"traitor_netgunner_catching_net",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_netgunner_catching_net",
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
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "traitor_netgunner_spawned",
		response = "traitor_netgunner_spawned",
		wwise_route = 14,
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
				"spawned",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_netgunner",
			},
			{
				"faction_memory",
				"faction_memory_traitor_netgunner_spawned",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_traitor_netgunner_spawned",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "traitor_netgunner_throwing_net",
		response = "traitor_netgunner_throwing_net",
		wwise_route = 14,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"throwing_net",
			},
			{
				"user_memory",
				"traitor_net_gunner_throwing_net",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_net_gunner_throwing_net",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_scout_shocktrooper_alerted_idle",
		response = "traitor_scout_shocktrooper_alerted_idle",
		wwise_route = 12,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper",
			},
			{
				"user_memory",
				"enemy_memory_traitor_scout_shocktrooper_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				6,
			},
			{
				"faction_memory",
				"faction_memory_traitor_scout_shocktrooper_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				3,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_traitor_scout_shocktrooper_alerted_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_scout_shocktrooper_alerted_idle",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_scout_shocktrooper_melee_idle",
		response = "traitor_scout_shocktrooper_melee_idle",
		wwise_route = 12,
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
				"melee_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper",
			},
			{
				"user_memory",
				"traitor_scout_shocktrooper_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
			{
				"faction_memory",
				"faction_memory_traitor_scout_shocktrooper_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_scout_shocktrooper_melee_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_scout_shocktrooper_melee_idle",
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
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_scout_shocktrooper_no_damage",
		response = "traitor_scout_shocktrooper_no_damage",
		wwise_route = 12,
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
				"no_damage_taunt",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper",
			},
			{
				"user_memory",
				"enemy_memory_no_damage_taunt",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_no_damage_taunt",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_no_damage_taunt",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_no_damage_taunt",
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
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_scout_shocktrooper_take_cover",
		response = "traitor_scout_shocktrooper_take_cover",
		wwise_route = 12,
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
				"take_cover",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper",
			},
			{
				"user_memory",
				"enemy_memory_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"faction_memory_take_cover",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"user_memory",
				"enemy_memory_take_cover",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_take_cover",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_scout_shocktrooper_take_position",
		response = "traitor_scout_shocktrooper_take_position",
		wwise_route = 12,
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
				"take_position",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper",
			},
			{
				"user_memory",
				"traitor_scout_shocktrooper_take_position",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
			{
				"faction_memory",
				"faction_memory_traitor_scout_shocktrooper_take_position",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_scout_shocktrooper_take_position",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_scout_shocktrooper_take_position",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_shocktrooper_start_shooting",
		response = "traitor_shocktrooper_start_shooting",
		wwise_route = 12,
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
				"start_shooting",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper",
			},
			{
				"faction_memory",
				"faction_memory_shocktrooper_start_shooting",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"faction_memory",
				"faction_memory_shocktrooper_start_shooting",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_trenchfighter_alerted_idle",
		response = "traitor_trenchfighter_alerted_idle",
		wwise_route = 16,
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
				"alerted_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_melee",
			},
			{
				"user_memory",
				"traitor_trenchfighter_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				10,
			},
			{
				"faction_memory",
				"faction_memory_traitor_trenchfighter_alerted_idle",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_trenchfighter_alerted_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_trenchfighter_alerted_idle",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_trenchfighter_assault",
		response = "traitor_trenchfighter_assault",
		wwise_route = 16,
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
				"assault",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_melee",
			},
			{
				"user_memory",
				"traitor_trenchfighter_assault",
				OP.TIMEDIFF,
				OP.GT,
				6,
			},
			{
				"faction_memory",
				"faction_trenchfighter_assault",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_trenchfighter_assault",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_trenchfighter_assault",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_1",
		database = "enemy_vo",
		name = "traitor_trenchfighter_melee_idle",
		response = "traitor_trenchfighter_melee_idle",
		wwise_route = 16,
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
				"melee_idle",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_melee",
			},
			{
				"user_memory",
				"traitor_trenchfighter_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				8,
			},
			{
				"faction_memory",
				"faction_memory_traitor_trenchfighter_melee_idle",
				OP.TIMEDIFF,
				OP.GT,
				4,
			},
		},
		on_done = {
			{
				"user_memory",
				"traitor_trenchfighter_melee_idle",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"faction_memory_traitor_trenchfighter_melee_idle",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "enemy_vo_prio_0",
		database = "enemy_vo",
		name = "twin_spawn_laugh_a",
		response = "twin_spawn_laugh_a",
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
				"taunt_disabled",
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
end
