-- chunkname: @dialogues/generated/class_rework.lua

return function ()
	define_rule({
		name = "ability_banisher",
		category = "player_prio_1",
		wwise_route = 31,
		response = "ability_banisher",
		database = "class_rework",
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
				"ability_banisher"
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
		name = "ability_banisher_impact",
		category = "player_prio_1",
		wwise_route = 24,
		response = "ability_banisher_impact",
		database = "class_rework",
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
				"ability_banisher_impact"
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
		name = "ability_buff_stance_a",
		category = "player_prio_1",
		wwise_route = 31,
		response = "ability_buff_stance_a",
		database = "class_rework",
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
				"ability_buff_stance"
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
		name = "ability_bullgryn",
		category = "player_prio_1",
		wwise_route = 30,
		response = "ability_bullgryn",
		database = "class_rework",
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
				"ability_bullgryn"
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
		name = "ability_gun_lugger",
		category = "player_prio_1",
		wwise_route = 30,
		response = "ability_gun_lugger",
		database = "class_rework",
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
				"ability_gun_lugger"
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
		name = "ability_gunslinger",
		wwise_route = 0,
		response = "ability_gunslinger",
		database = "class_rework",
		category = "player_prio_1",
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
				"ability_gunslinger"
			},
			{
				"user_context",
				"enemies_close",
				OP.EQ,
				0
			},
			{
				"user_context",
				"enemies_distant",
				OP.GT,
				0
			},
			{
				"user_memory",
				"ability_gunslinger",
				OP.TIMEDIFF,
				OP.GT,
				45
			}
		},
		on_done = {
			{
				"user_memory",
				"ability_gunslinger",
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
				chance = 0.2,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "ability_litany_temp",
		category = "player_prio_1",
		wwise_route = 31,
		response = "ability_litany_temp",
		database = "class_rework",
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
				"ability_litany"
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
		name = "ability_pious_stabber",
		category = "player_prio_1",
		wwise_route = 31,
		response = "ability_pious_stabber",
		database = "class_rework",
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
				"ability_pious_stabber"
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
		name = "ability_protectorate_start",
		category = "player_prio_1",
		wwise_route = 31,
		response = "ability_protectorate_start",
		database = "class_rework",
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
				"ability_protectorate_start"
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
		name = "ability_protectorate_stop",
		category = "player_prio_1",
		wwise_route = 24,
		response = "ability_protectorate_stop",
		database = "class_rework",
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
				"ability_protectorate_stop"
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
		name = "ability_shock_trooper",
		category = "player_prio_1",
		wwise_route = 31,
		response = "ability_shock_trooper",
		database = "class_rework",
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
				"ability_shock_trooper"
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
		name = "ability_squad_leader",
		category = "player_ability_vo",
		wwise_route = 30,
		response = "ability_squad_leader",
		database = "class_rework",
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
				"ability_squad_leader"
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
end
