-- chunkname: @dialogues/generated/event_vo_delivery.lua

return function ()
	define_rule({
		category = "player_prio_0",
		database = "event_vo_delivery",
		name = "luggable_mission_pick_up_dm_propaganda",
		response = "luggable_mission_pick_up_dm_propaganda",
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
				"luggable_wield_battery",
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"dm_propaganda",
			},
			{
				"faction_memory",
				"luggable_mission_pick_up",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"mission_propaganda_view_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"luggable_mission_pick_up",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default_class",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "event_vo_delivery",
		name = "luggable_mission_pick_up_lm_cooling",
		response = "luggable_mission_pick_up_lm_cooling",
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
				"luggable_wield",
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"lm_cooling",
			},
			{
				"faction_memory",
				"luggable_mission_pick_up",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"luggable_mission_pick_up",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default_class",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "event_vo_delivery",
		name = "luggable_mission_pick_up_lm_rails",
		response = "luggable_mission_pick_up_lm_rails",
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
				"luggable_wield",
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"lm_rails",
			},
			{
				"faction_memory",
				"luggable_mission_pick_up",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"luggable_mission_pick_up",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default_class",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "player_prio_0",
		database = "event_vo_delivery",
		name = "luggable_mission_pick_up_lm_scavenge",
		response = "luggable_mission_pick_up_lm_scavenge",
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
				"luggable_wield",
			},
			{
				"global_context",
				"current_mission",
				OP.EQ,
				"lm_scavenge",
			},
			{
				"faction_memory",
				"luggable_mission_pick_up",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"luggable_mission_pick_up",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_giver_default_class",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
end
