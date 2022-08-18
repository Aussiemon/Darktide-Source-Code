return function ()
	define_rule({
		name = "luggable_mission_pick_up_dm_propaganda",
		wwise_route = 0,
		response = "luggable_mission_pick_up_dm_propaganda",
		database = "event_vo_delivery",
		category = "player_prio_0",
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
				"luggable_wield"
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"dm_propaganda"
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
				"luggable_mission_pick_up",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "luggable_mission_pick_up_lm_cooling",
		wwise_route = 0,
		response = "luggable_mission_pick_up_lm_cooling",
		database = "event_vo_delivery",
		category = "player_prio_0",
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
				"luggable_wield"
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"lm_cooling"
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
				"luggable_mission_pick_up",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "luggable_mission_pick_up_lm_rails",
		wwise_route = 0,
		response = "luggable_mission_pick_up_lm_rails",
		database = "event_vo_delivery",
		category = "player_prio_0",
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
				"luggable_wield"
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"lm_rails"
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
				"luggable_mission_pick_up",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "luggable_mission_pick_up_lm_scavenge",
		wwise_route = 0,
		response = "luggable_mission_pick_up_lm_scavenge",
		database = "event_vo_delivery",
		category = "player_prio_0",
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
				"luggable_wield"
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"lm_scavenge"
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
				"luggable_mission_pick_up",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
end
