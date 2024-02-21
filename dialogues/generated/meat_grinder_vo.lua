return function ()
	define_rule({
		name = "hub_rumour_cult_01_a",
		category = "conversations_prio_0",
		wwise_route = 42,
		response = "hub_rumour_cult_01_a",
		database = "meat_grinder_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"user_memory",
				"hub_rumour_cult_01_a",
				OP.TIMEDIFF,
				OP.GT,
				900
			}
		},
		on_done = {
			{
				"user_memory",
				"hub_rumour_cult_01_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		name = "hub_rumour_escalation_01_a",
		category = "conversations_prio_0",
		wwise_route = 42,
		response = "hub_rumour_escalation_01_a",
		database = "meat_grinder_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"user_memory",
				"hub_rumour_escalation_01_a",
				OP.TIMEDIFF,
				OP.GT,
				900
			}
		},
		on_done = {
			{
				"user_memory",
				"hub_rumour_escalation_01_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		name = "hub_rumour_hub_crew_01_a",
		category = "conversations_prio_0",
		wwise_route = 42,
		response = "hub_rumour_hub_crew_01_a",
		database = "meat_grinder_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"user_memory",
				"hur_rumour_hub_crew_01_a",
				OP.TIMEDIFF,
				OP.GT,
				900
			}
		},
		on_done = {
			{
				"user_memory",
				"hur_rumour_hub_crew_01_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		name = "hub_rumour_politics_01_a",
		category = "conversations_prio_0",
		wwise_route = 42,
		response = "hub_rumour_politics_01_a",
		database = "meat_grinder_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"user_memory",
				"hub_rumour_politics_01_a",
				OP.TIMEDIFF,
				OP.GT,
				900
			}
		},
		on_done = {
			{
				"user_memory",
				"hub_rumour_politics_01_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
	define_rule({
		name = "hub_rumour_wanderers_01_a",
		category = "conversations_prio_0",
		wwise_route = 42,
		response = "hub_rumour_wanderers_01_a",
		database = "meat_grinder_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker"
				}
			},
			{
				"user_memory",
				"hub_rumour_wanderers_01_a",
				OP.TIMEDIFF,
				OP.GT,
				900
			}
		},
		on_done = {
			{
				"user_memory",
				"hub_rumour_wanderers_01_a",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "mission_givers"
		}
	})
end
