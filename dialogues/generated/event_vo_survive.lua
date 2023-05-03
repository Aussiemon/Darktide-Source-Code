return function ()
	define_rule({
		name = "event_survive_almost_done",
		category = "player_prio_0",
		wwise_route = 0,
		response = "event_survive_almost_done",
		database = "event_vo_survive",
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
				"event_survive_almost_done"
			},
			{
				"faction_memory",
				"event_survive_almost_done",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_survive_almost_done",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "event_survive_keep_coming_a",
		category = "player_prio_0",
		wwise_route = 0,
		response = "event_survive_keep_coming_a",
		database = "event_vo_survive",
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
				"event_survive_keep_coming_a"
			},
			{
				"faction_memory",
				"event_survive_keep_coming_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"event_survive_keep_coming_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
end
