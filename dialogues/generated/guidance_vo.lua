return function ()
	define_rule({
		name = "guidance_correct_doorway",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_correct_doorway",
		database = "guidance_vo",
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
				"guidance_correct_doorway"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"",
				OP.ADD,
				0
			}
		}
	})
	define_rule({
		name = "guidance_correct_path",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_correct_path",
		database = "guidance_vo",
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
				"guidance_correct_path"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"guidance_correct_path",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_correct_path",
				OP.ADD,
				0
			}
		}
	})
	define_rule({
		name = "guidance_correct_path_1",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_correct_path_1",
		database = "guidance_vo",
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
				"guidance_correct_path_1"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"guidance_correct_path_1",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_correct_path_1",
				OP.ADD,
				0
			}
		}
	})
	define_rule({
		name = "guidance_correct_path_2",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_correct_path_2",
		database = "guidance_vo",
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
				"guidance_correct_path_2"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"guidance_correct_path_2",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_correct_path_2",
				OP.ADD,
				0
			}
		}
	})
	define_rule({
		name = "guidance_correct_path_3",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_correct_path_3",
		database = "guidance_vo",
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
				"guidance_correct_path_3"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"guidance_correct_path_3",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_correct_path_3",
				OP.ADD,
				0
			}
		}
	})
	define_rule({
		name = "guidance_correct_path_drop",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_correct_path_drop",
		database = "guidance_vo",
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
				"guidance_correct_path_drop"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"guidance_correct_path_drop",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_correct_path_drop",
				OP.ADD,
				0
			}
		}
	})
	define_rule({
		name = "guidance_correct_path_drop_1",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_correct_path_drop_1",
		database = "guidance_vo",
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
				"guidance_correct_path_drop_1"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				0
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_1",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_1",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "guidance_correct_path_drop_2",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_correct_path_drop_2",
		database = "guidance_vo",
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
				"guidance_correct_path_drop_2"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				0
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_2",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_2",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "guidance_correct_path_drop_3",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_correct_path_drop_3",
		database = "guidance_vo",
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
				"guidance_correct_path_drop_3"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				0
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_3",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_3",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "guidance_correct_path_drop_4",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_correct_path_drop_4",
		database = "guidance_vo",
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
				"guidance_correct_path_drop_4"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				0
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_4",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_4",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "guidance_correct_path_drop_5",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_correct_path_drop_5",
		database = "guidance_vo",
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
				"guidance_correct_path_drop_5"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				0
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_5",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_5",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "guidance_correct_path_drop_6",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_correct_path_drop_6",
		database = "guidance_vo",
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
				"guidance_correct_path_drop_6"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				0
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_6",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_correct_path_drop_6",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "guidance_correct_path_up",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_correct_path_up",
		database = "guidance_vo",
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
				"guidance_correct_path_up"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "guidance_ladder_down",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_ladder_down",
		database = "guidance_vo",
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
				"guidance_correct_path_ladder_down"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"",
				OP.ADD,
				0
			}
		}
	})
	define_rule({
		name = "guidance_ladder_sighted",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_ladder_sighted",
		database = "guidance_vo",
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
				"guidance_ladder_sighted"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET,
				"0"
			}
		}
	})
	define_rule({
		name = "guidance_ladder_up",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_ladder_up",
		database = "guidance_vo",
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
				"guidance_correct_path_ladder_up"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"",
				OP.ADD,
				0
			}
		}
	})
	define_rule({
		name = "guidance_stairs_down",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_stairs_down",
		database = "guidance_vo",
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
				"guidance_correct_path_stairs_down"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"",
				OP.ADD,
				0
			}
		}
	})
	define_rule({
		name = "guidance_stairs_sighted",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_stairs_sighted",
		database = "guidance_vo",
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
				"guidance_stairs_sighted"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"guidance_stairs_sighted",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_stairs_sighted",
				OP.ADD,
				0
			}
		}
	})
	define_rule({
		name = "guidance_stairs_sighted_1",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_stairs_sighted_1",
		database = "guidance_vo",
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
				"guidance_stairs_sighted_1"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_1",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_1",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "guidance_stairs_sighted_2",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_stairs_sighted_2",
		database = "guidance_vo",
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
				"guidance_stairs_sighted_2"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_2",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_2",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "guidance_stairs_sighted_3",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_stairs_sighted_3",
		database = "guidance_vo",
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
				"guidance_stairs_sighted_3"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_3",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_3",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "guidance_stairs_sighted_4",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_stairs_sighted_4",
		database = "guidance_vo",
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
				"guidance_stairs_sighted_4"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_4",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"guidance_stairs_sighted_4",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "guidance_stairs_up",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_stairs_up",
		database = "guidance_vo",
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
				"guidance_correct_path_stairs_up"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				5
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			},
			{
				"faction_memory",
				"",
				OP.ADD,
				0
			}
		}
	})
	define_rule({
		name = "guidance_starting_area",
		category = "player_prio_0",
		wwise_route = 0,
		response = "guidance_starting_area",
		database = "guidance_vo",
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
				"guidance_starting_area"
			},
			{
				"faction_memory",
				"guidance_starting_area",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"guidance_starting_area",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "guidance_switch",
		category = "player_prio_2",
		wwise_route = 0,
		response = "guidance_switch",
		database = "guidance_vo",
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
				"guidance_switch"
			},
			{
				"user_context",
				"threat_level",
				OP.SET_INCLUDES,
				args = {
					"low",
					"medium",
					"high"
				}
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				15
			},
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_found_way",
				OP.TIMESET
			}
		}
	})
	define_rule({
		pre_wwise_event = "play_radio_static_start",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "info_asset_cult_breaking_wheel",
		post_wwise_event = "play_radio_static_end",
		response = "info_asset_cult_breaking_wheel",
		database = "guidance_vo",
		wwise_route = 1,
		category = "vox_prio_0",
		speaker_routing = {
			target = "all"
		},
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
				"info_asset_cult_breaking_wheel"
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
					"pilot",
					"sergeant",
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"info_asset_cult_breaking_wheel",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"info_asset_cult_breaking_wheel",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		concurrent_wwise_event = "play_vox_static_loop",
		wwise_route = 1,
		name = "info_asset_nurgle_growth",
		response = "info_asset_nurgle_growth",
		database = "guidance_vo",
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
				"info_asset_nurgle_growth"
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
				"info_asset_nurgle_growth",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"info_asset_nurgle_growth",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
end
