return function ()
	define_rule({
		name = "luggable_mission_pick_up",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "luggable_mission_pick_up",
		database = "mission_vo",
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
				"luggable_mission_pick_up"
			},
			{
				"user_context",
				"threat_level",
				OP.EQ,
				"low"
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
				20
			},
			{
				"faction_memory",
				"time_since_luggable_mission_pick_up",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"luggable_mission_pick_up",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_luggable_mission_pick_up",
				OP.TIMESET
			},
			{
				"faction_memory",
				"luggable_mission_pick_up",
				OP.ADD,
				1
			}
		}
	})
end
