return function ()
	define_rule({
		name = "asset_acid_clouds",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "asset_acid_clouds",
		database = "asset_vo",
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
				"asset_acid_clouds"
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
				17
			},
			{
				"faction_memory",
				"asset_acid_clouds",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"asset_acid_clouds",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "asset_cartel_insignia",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "asset_cartel_insignia",
		database = "asset_vo",
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
				"asset_cartel_insignia"
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
				17
			},
			{
				"faction_memory",
				"asset_cartel_insignia",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"asset_cartel_insignia",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "asset_foul_smoke",
		category = "player_prio_0",
		wwise_route = 0,
		response = "asset_foul_smoke",
		database = "asset_vo",
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
				"asset_foul_smoke"
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
				"faction_memory",
				"asset_foul_smoke",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"asset_foul_smoke",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "asset_goo",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "asset_goo",
		database = "asset_vo",
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
				"asset_goo"
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
				17
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				50
			},
			{
				"faction_memory",
				"last_seen_asset_goo",
				OP.TIMEDIFF,
				OP.GT,
				120
			},
			{
				"faction_memory",
				"asset_goo",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_asset_goo",
				OP.TIMESET
			},
			{
				"faction_memory",
				"asset_goo",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "asset_grease_pit",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "asset_grease_pit",
		database = "asset_vo",
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
				"asset_grease_pit"
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
				10
			},
			{
				"faction_memory",
				"last_seen_asset_grease_pit",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"asset_grease_pit",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_seen_asset_grease_pit",
				OP.TIMESET
			},
			{
				"faction_memory",
				"asset_grease_pit",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "asset_pneumatic_press",
		response = "asset_pneumatic_press",
		database = "asset_vo",
		wwise_route = 1,
		category = "vox_prio_0",
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
				"asset_pneumatic_press"
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
				17
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			},
			{
				"faction_memory",
				"asset_pneumatic_press",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"asset_pneumatic_press",
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
		name = "asset_sigil",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "asset_sigil",
		database = "asset_vo",
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
				"asset_sigil"
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
				17
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				20
			},
			{
				"faction_memory",
				"time_since_asset_sigil",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"faction_memory",
				"asset_sigil",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_asset_sigil",
				OP.TIMESET
			},
			{
				"faction_memory",
				"asset_sigil",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "asset_unnatural_dark_a",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "asset_unnatural_dark_a",
		database = "asset_vo",
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
				"asset_unnatural_dark_a"
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
				17
			},
			{
				"faction_memory",
				"asset_unnatural_dark_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"asset_unnatural_dark_a",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		name = "asset_unnatural_dark_b",
		category = "player_prio_1",
		wwise_route = 0,
		response = "asset_unnatural_dark_b",
		database = "asset_vo",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"asset_unnatural_dark_a"
				}
			},
			{
				"user_memory",
				"asset_unnatural_dark_b",
				OP.TIMEDIFF,
				OP.GT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"asset_unnatural_dark_b",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "asset_water_course",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "asset_water_course",
		database = "asset_vo",
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
				"asset_water_course"
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
				17
			},
			{
				"faction_memory",
				"asset_water_course",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"asset_water_course",
				OP.ADD,
				1
			}
		}
	})
end
