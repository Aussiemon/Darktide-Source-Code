-- chunkname: @dialogues/generated/on_demand_vo.lua

return function ()
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "com_wheel_vo_enemy_over_here",
		response = "com_wheel_vo_enemy_over_here",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_com_wheel",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"location_enemy_there",
			},
			{
				"user_memory",
				"time_since_com_wheel_vo_enemy_over_here",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_com_wheel_vo_enemy_over_here",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "com_wheel_vo_follow_you",
		response = "com_wheel_vo_follow_you",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_com_wheel",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"answer_following",
			},
			{
				"user_memory",
				"time_since_com_wheel_vo_follow_you",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_com_wheel_vo_follow_you",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "com_wheel_vo_for_the_emperor",
		response = "com_wheel_vo_for_the_emperor",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_com_wheel",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"com_cheer",
			},
			{
				"user_memory",
				"time_since_com_wheel_vo_for_the_emperor",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_com_wheel_vo_for_the_emperor",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "com_wheel_vo_lets_go_this_way",
		response = "com_wheel_vo_lets_go_this_way",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_com_wheel",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"location_this_way",
			},
			{
				"user_memory",
				"time_since_com_wheel_vo_lets_go_this_way",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_com_wheel_vo_lets_go_this_way",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "com_wheel_vo_need_ammo",
		response = "com_wheel_vo_need_ammo",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_com_wheel",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"com_need_ammo",
			},
			{
				"user_memory",
				"time_since_com_wheel_vo_need_ammo",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_com_wheel_vo_need_ammo",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "com_wheel_vo_need_health",
		response = "com_wheel_vo_need_health",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_com_wheel",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"com_need_health",
			},
			{
				"user_memory",
				"time_since_com_wheel_vo_need_health",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_com_wheel_vo_need_health",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "com_wheel_vo_need_that",
		response = "com_wheel_vo_need_that",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_com_wheel",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"answer_need",
			},
			{
				"user_memory",
				"time_since_com_wheel_vo_need_health",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_com_wheel_vo_need_health",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "com_wheel_vo_no",
		response = "com_wheel_vo_no",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_com_wheel",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"answer_no",
			},
			{
				"user_memory",
				"time_since_com_wheel_vo_no",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_com_wheel_vo_no",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "com_wheel_vo_over_here",
		response = "com_wheel_vo_over_here",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_com_wheel",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"location_over_here",
			},
			{
				"user_memory",
				"time_since_com_wheel_vo_over_here",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_com_wheel_vo_over_here",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "com_wheel_vo_thank_you",
		response = "com_wheel_vo_thank_you",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_com_wheel",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"com_thank_you",
			},
			{
				"user_memory",
				"time_since_com_wheel_vo_over_here",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_com_wheel_vo_over_here",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "com_wheel_vo_thank_you_delayed",
		response = "com_wheel_vo_thank_you_delayed",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_com_wheel",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"com_thank_you_delayed",
			},
			{
				"user_memory",
				"time_since_com_wheel_vo_over_here",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_com_wheel_vo_over_here",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.7,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "com_wheel_vo_yes",
		response = "com_wheel_vo_yes",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_com_wheel",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"answer_yes",
			},
			{
				"user_memory",
				"time_since_com_wheel_vo_yes",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_com_wheel_vo_yes",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "on_demand_vo",
		name = "response_for_seen_enemy_netgunner_flee",
		response = "response_for_seen_enemy_netgunner_flee",
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
					"smart_tag_vo_seen_netgunner_flee",
				},
			},
			{
				"faction_memory",
				"seen_netgunner_flee_response",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"user_memory",
				"",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"seen_netgunner_flee_response",
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
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_berserker",
		response = "smart_tag_vo_enemy_berserker",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_berzerker",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_berserker",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_captain",
		response = "smart_tag_vo_enemy_captain",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_captain",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_renegade_captain",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_chaos_hound",
		response = "smart_tag_vo_enemy_chaos_hound",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_hound",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_chaos_hound",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_chaos_mutant_charger",
		response = "smart_tag_vo_enemy_chaos_mutant_charger",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_mutant",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_cultist_mutant",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_chaos_ogryn_armored_executor",
		response = "smart_tag_vo_enemy_chaos_ogryn_armored_executor",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_executor",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_chaos_ogryn_executor",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_chaos_ogryn_bulwark",
		response = "smart_tag_vo_enemy_chaos_ogryn_bulwark",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_bulwark",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
			{
				"faction_memory",
				"enemy_chaos_ogryn_bulwark",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_chaos_ogryn_bulwark",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_chaos_ogryn_heavy_gunner",
		response = "smart_tag_vo_enemy_chaos_ogryn_heavy_gunner",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_ogryn_gunner",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_chaos_ogryn_gunner",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_chaos_poxwalker_bomber",
		response = "smart_tag_vo_enemy_chaos_poxwalker_bomber",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_poxwalker_bomber",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_chaos_poxwalker_bomber",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_chaos_spawn",
		response = "smart_tag_vo_enemy_chaos_spawn",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_spawn",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_renegade_sniper",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_cultist_flamer",
		response = "smart_tag_vo_enemy_cultist_flamer",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_flamer",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_cultist_flamer",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_cultist_grenadier",
		response = "smart_tag_vo_enemy_cultist_grenadier",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_grenadier",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_grenadier",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_cultist_holy_stubber_gunner",
		response = "smart_tag_vo_enemy_cultist_holy_stubber_gunner",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_gunner",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_cultist_gunner",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_cultist_shocktrooper",
		response = "smart_tag_vo_enemy_cultist_shocktrooper",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"cultist_shocktrooper",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
			{
				"faction_memory",
				"enemy_shocktrooper",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_cultist_shocktrooper",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_daemonhost_witch",
		response = "smart_tag_vo_enemy_daemonhost_witch",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"aggroed",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_chaos_daemonhost",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_daemonhost_witch_not_alerted",
		response = "smart_tag_vo_enemy_daemonhost_witch_not_alerted",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_daemonhost",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_chaos_daemonhost",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_netgunner",
		response = "smart_tag_vo_enemy_netgunner",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_netgunner",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_renegade_netgunner",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_plague_ogryn",
		response = "smart_tag_vo_enemy_plague_ogryn",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"chaos_plague_ogryn",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_chaos_plague_ogryn",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_renegade_berserker",
		response = "smart_tag_vo_enemy_renegade_berserker",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_berzerker",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_berserker",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_scab_flamer",
		response = "smart_tag_vo_enemy_scab_flamer",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_flamer",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_renegade_flamer",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_traitor_executor",
		response = "smart_tag_vo_enemy_traitor_executor",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_executor",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_renegade_executor",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_traitor_grenadier",
		response = "smart_tag_vo_enemy_traitor_grenadier",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_grenadier",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_grenadier",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_traitor_gunner",
		response = "smart_tag_vo_enemy_traitor_gunner",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_gunner",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_renegade_gunner",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_traitor_scout_shocktrooper",
		response = "smart_tag_vo_enemy_traitor_scout_shocktrooper",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_shocktrooper",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
			{
				"faction_memory",
				"enemy_shocktrooper",
				OP.TIMEDIFF,
				OP.GT,
				2,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_renegade_shocktrooper",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_enemy_traitor_sniper",
		response = "smart_tag_vo_enemy_traitor_sniper",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"renegade_sniper",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_renegade_sniper",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_pickup_ammo",
		response = "smart_tag_vo_pickup_ammo",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_ammo",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_ammo",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_pickup_battery",
		response = "smart_tag_vo_pickup_battery",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_battery",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_battery",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_pickup_container",
		response = "smart_tag_vo_pickup_container",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_container",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_container",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_pickup_control_rod",
		response = "smart_tag_vo_pickup_control_rod",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_control_rod",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_control_rod",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_pickup_deployed_ammo_crate",
		response = "smart_tag_vo_pickup_deployed_ammo_crate",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_deployed_ammo_crate",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_deployed_ammo_crate",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_pickup_deployed_medical_crate",
		response = "smart_tag_vo_pickup_deployed_medical_crate",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_deployed_medical_crate",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_deployed_medical_crate",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_pickup_forge_metal",
		response = "smart_tag_vo_pickup_forge_metal",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_forge_metal",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_forge_metal",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_pickup_health_booster",
		response = "smart_tag_vo_pickup_health_booster",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_health_booster",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_health_booster",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_pickup_medical_crate",
		response = "smart_tag_vo_pickup_medical_crate",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_medical_crate",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_medical_crate",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_pickup_platinum",
		response = "smart_tag_vo_pickup_platinum",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_platinum",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_platinum",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_pickup_side_mission_consumable",
		response = "smart_tag_vo_pickup_side_mission_consumable",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_side_mission_consumable",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_side_mission_consumable",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_pickup_side_mission_grimoire",
		response = "smart_tag_vo_pickup_side_mission_grimoire",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_side_mission_grimoire",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_side_mission_grimoire",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_pickup_side_mission_tome",
		response = "smart_tag_vo_pickup_side_mission_tome",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_side_mission_tome",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_side_mission_tome",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_seen_netgunner_flee",
		response = "smart_tag_vo_seen_netgunner_flee",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_enemy",
			},
			{
				"query_context",
				"enemy_tag",
				OP.EQ,
				"seen_netgunner_flee",
			},
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
			{
				"faction_memory",
				"seen_netgunner_flee",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"enemy_renegade_netgunner",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"seen_netgunner_flee",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_small_grenade",
		response = "smart_tag_vo_small_grenade",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"pup_small_grenade",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_small_grenade",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_station_health",
		response = "smart_tag_vo_station_health",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"station_health",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
			{
				"user_memory",
				"last_saw_health",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_health_station",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
	define_rule({
		category = "player_on_demand_vo",
		database = "on_demand_vo",
		name = "smart_tag_vo_station_health_without_battery",
		response = "smart_tag_vo_station_health_without_battery",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"on_demand_vo_tag_item",
			},
			{
				"query_context",
				"item_tag",
				OP.EQ,
				"station_health_without_battery",
			},
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"time_since_smart_tag_item",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_saw_station_health_without_battery",
				OP.TIMESET,
			},
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.15,
			},
		},
	})
end
