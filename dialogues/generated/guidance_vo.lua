-- chunkname: @dialogues/generated/guidance_vo.lua

return function ()
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_correct_doorway",
		response = "guidance_correct_doorway",
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
				"guidance_correct_doorway",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"",
				OP.ADD,
				0,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_correct_path",
		response = "guidance_correct_path",
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
				"guidance_correct_path",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"guidance_correct_path",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_correct_path",
				OP.ADD,
				0,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_correct_path_1",
		response = "guidance_correct_path_1",
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
				"guidance_correct_path_1",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"guidance_correct_path_1",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_correct_path_1",
				OP.ADD,
				0,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_correct_path_2",
		response = "guidance_correct_path_2",
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
				"guidance_correct_path_2",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"guidance_correct_path_2",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_correct_path_2",
				OP.ADD,
				0,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_correct_path_3",
		response = "guidance_correct_path_3",
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
				"guidance_correct_path_3",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"guidance_correct_path_3",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_correct_path_3",
				OP.ADD,
				0,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_correct_path_drop",
		response = "guidance_correct_path_drop",
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
				"guidance_correct_path_drop",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop",
				OP.ADD,
				0,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_correct_path_drop_1",
		response = "guidance_correct_path_drop_1",
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
				"guidance_correct_path_drop_1",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				0,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_1",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_1",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_correct_path_drop_2",
		response = "guidance_correct_path_drop_2",
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
				"guidance_correct_path_drop_2",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				0,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_2",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_2",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_correct_path_drop_3",
		response = "guidance_correct_path_drop_3",
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
				"guidance_correct_path_drop_3",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				0,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_3",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_3",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_correct_path_drop_4",
		response = "guidance_correct_path_drop_4",
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
				"guidance_correct_path_drop_4",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				0,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_4",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_4",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_correct_path_drop_5",
		response = "guidance_correct_path_drop_5",
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
				"guidance_correct_path_drop_5",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				0,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_5",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_5",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_correct_path_drop_6",
		response = "guidance_correct_path_drop_6",
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
				"guidance_correct_path_drop_6",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				0,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_6",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_6",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_correct_path_up",
		response = "guidance_correct_path_up",
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
				"guidance_correct_path_up",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_ladder_down",
		response = "guidance_ladder_down",
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
				"guidance_correct_path_ladder_down",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"",
				OP.ADD,
				0,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_ladder_sighted",
		response = "guidance_ladder_sighted",
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
				"guidance_ladder_sighted",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				20,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
				"0",
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_ladder_up",
		response = "guidance_ladder_up",
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
				"guidance_correct_path_ladder_up",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"",
				OP.ADD,
				0,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_stairs_down",
		response = "guidance_stairs_down",
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
				"guidance_correct_path_stairs_down",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"",
				OP.ADD,
				0,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_stairs_sighted",
		response = "guidance_stairs_sighted",
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
				"guidance_stairs_sighted",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"guidance_stairs_sighted",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_stairs_sighted",
				OP.ADD,
				0,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_stairs_sighted_1",
		response = "guidance_stairs_sighted_1",
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
				"guidance_stairs_sighted_1",
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
				10,
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_1",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_1",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_stairs_sighted_2",
		response = "guidance_stairs_sighted_2",
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
				"guidance_stairs_sighted_2",
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
				10,
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_2",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_2",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_stairs_sighted_3",
		response = "guidance_stairs_sighted_3",
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
				"guidance_stairs_sighted_3",
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
				10,
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_3",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_3",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_stairs_sighted_4",
		response = "guidance_stairs_sighted_4",
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
				"guidance_stairs_sighted_4",
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
				10,
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_4",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_4",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_stairs_up",
		response = "guidance_stairs_up",
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
				"guidance_correct_path_stairs_up",
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
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"",
				OP.ADD,
				0,
			},
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "guidance_vo",
		name = "guidance_starting_area",
		response = "guidance_starting_area",
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
				"guidance_starting_area",
			},
			{
				"faction_memory",
				"guidance_starting_area",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"guidance_starting_area",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "player_prio_2",
		database = "guidance_vo",
		name = "guidance_switch",
		response = "guidance_switch",
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
				"guidance_switch",
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high",
				},
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				15,
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
			},
		},
	})
end
