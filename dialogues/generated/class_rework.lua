-- chunkname: @dialogues/generated/class_rework.lua

return function ()
	define_rule({
		category = "player_prio_1",
		database = "class_rework",
		name = "ability_banisher",
		response = "ability_banisher",
		wwise_route = 31,
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
				"ability_banisher",
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
		database = "class_rework",
		name = "ability_banisher_impact",
		response = "ability_banisher_impact",
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
				"ability_banisher_impact",
			},
			{
				"user_context",
				"enemies_close",
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
		database = "class_rework",
		name = "ability_buff_stance_a",
		response = "ability_buff_stance_a",
		wwise_route = 31,
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
				"ability_buff_stance",
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
		database = "class_rework",
		name = "ability_bullgryn",
		response = "ability_bullgryn",
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
				"ability_bullgryn",
			},
			{
				"user_context",
				"enemies_close",
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
		database = "class_rework",
		name = "ability_gun_lugger",
		response = "ability_gun_lugger",
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
				"ability_gun_lugger",
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
		database = "class_rework",
		name = "ability_gunslinger",
		response = "ability_gunslinger",
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
				"ability_gunslinger",
			},
			{
				"user_context",
				"enemies_close",
				OP.EQ,
				0,
			},
			{
				"user_context",
				"enemies_distant",
				OP.GT,
				0,
			},
			{
				"user_memory",
				"ability_gunslinger",
				OP.TIMEDIFF,
				OP.GT,
				45,
			},
		},
		on_done = {
			{
				"user_memory",
				"ability_gunslinger",
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
			random_ignore_vo = {
				chance = 0.2,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "player_prio_1",
		database = "class_rework",
		name = "ability_litany_temp",
		response = "ability_litany_temp",
		wwise_route = 31,
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
				"ability_litany",
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
		database = "class_rework",
		name = "ability_pious_stabber",
		response = "ability_pious_stabber",
		wwise_route = 31,
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
				"ability_pious_stabber",
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
		database = "class_rework",
		name = "ability_protectorate_start",
		response = "ability_protectorate_start",
		wwise_route = 31,
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
				"ability_protectorate_start",
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
		database = "class_rework",
		name = "ability_protectorate_stop",
		response = "ability_protectorate_stop",
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
				"ability_protectorate_stop",
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
		database = "class_rework",
		name = "ability_shock_trooper",
		response = "ability_shock_trooper",
		wwise_route = 31,
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
				"ability_shock_trooper",
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
		database = "class_rework",
		name = "ability_squad_leader",
		response = "ability_squad_leader",
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
				"ability_squad_leader",
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
end
