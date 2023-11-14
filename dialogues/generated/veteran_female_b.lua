return function ()
	define_rule({
		name = "bonding_conversation_creed_a",
		wwise_route = 0,
		response = "bonding_conversation_creed_a",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_veteran_female_c__combat_pause_quirk_veteran_a_professional_b_02",
					"loc_veteran_female_c__combat_pause_quirk_expendable_b_01",
					"loc_veteran_female_c__combat_pause_limited_veteran_a_14_b_01",
					""
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_creed_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_creed_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_creed_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_creed_b",
		wwise_route = 0,
		response = "bonding_conversation_creed_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_creed_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_c"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_creed_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_creed_c",
		wwise_route = 0,
		response = "bonding_conversation_creed_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_creed_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_creed_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_creed_d",
		wwise_route = 0,
		response = "bonding_conversation_creed_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_creed_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_creed_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_creed_e",
		wwise_route = 0,
		response = "bonding_conversation_creed_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_creed_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_creed_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_creed_f",
		wwise_route = 0,
		response = "bonding_conversation_creed_f",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_creed_e"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_creed_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_creed_g",
		wwise_route = 0,
		response = "bonding_conversation_creed_g",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_creed_f"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_creed_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_b_ogr_c_b",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_b_ogr_c_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_ogryn_c__head_shot_01",
					"loc_ogryn_c__head_shot_02",
					"loc_ogryn_c__head_shot_03",
					"loc_ogryn_c__head_shot_04",
					"loc_ogryn_c__head_shot_05",
					"loc_ogryn_c__head_shot_06",
					"loc_ogryn_c__head_shot_07",
					"loc_ogryn_c__head_shot_08",
					"loc_ogryn_c__head_shot_09",
					"loc_ogryn_c__head_shot_10"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_headshot",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_headshot_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_b_ogr_c_c",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_b_ogr_c_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_headshot_extension_vet_b_ogr_c_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_c"
				}
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_headshot_replier",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_b_psy_b_b",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_b_psy_b_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_psyker_male_b__head_shot_01",
					"loc_psyker_male_b__head_shot_02",
					"loc_psyker_male_b__head_shot_03",
					"loc_psyker_male_b__head_shot_04",
					"loc_psyker_male_b__head_shot_05",
					"loc_psyker_male_b__head_shot_06",
					"loc_psyker_male_b__head_shot_07",
					"loc_psyker_male_b__head_shot_08",
					"loc_psyker_male_b__head_shot_09",
					"loc_psyker_male_b__head_shot_10"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_headshot",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_headshot_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_b_psy_b_c",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_b_psy_b_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_headshot_extension_vet_b_psy_b_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_headshot_replier",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_b_psy_b_d",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_b_psy_b_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_headshot_extension_vet_b_psy_b_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_headshot_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_b_psy_b_e",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_b_psy_b_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_headshot_extension_vet_b_psy_b_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_headshot_replier",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_b_vet_a_b",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_b_vet_a_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_veteran_female_a__head_shot_01",
					"loc_veteran_female_a__head_shot_02",
					"loc_veteran_female_a__head_shot_03",
					"loc_veteran_female_a__head_shot_04",
					"loc_veteran_female_a__head_shot_05",
					"loc_veteran_female_a__head_shot_06",
					"loc_veteran_female_a__head_shot_07",
					"loc_veteran_female_a__head_shot_08",
					"loc_veteran_female_a__head_shot_09",
					"loc_veteran_female_a__head_shot_10"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_headshot",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_headshot_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_b_vet_a_c",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_b_vet_a_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_headshot_extension_vet_b_vet_a_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_headshot_replier",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_b_vet_a_d",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_b_vet_a_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_headshot_extension_vet_b_vet_a_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_headshot_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_b_vet_a_e",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_b_vet_a_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_headshot_extension_vet_b_vet_a_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_headshot_replier",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_b_zea_a_b",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_b_zea_a_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_zealot_male_a__head_shot_01",
					"loc_zealot_male_a__head_shot_02",
					"loc_zealot_male_a__head_shot_03",
					"loc_zealot_male_a__head_shot_04",
					"loc_zealot_male_a__head_shot_05",
					"loc_zealot_male_a__head_shot_06",
					"loc_zealot_male_a__head_shot_07",
					"loc_zealot_male_a__head_shot_08",
					"loc_zealot_male_a__head_shot_09",
					"loc_zealot_male_a__head_shot_10"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_headshot",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_headshot_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_headshot_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_b_zea_a_c",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_b_zea_a_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_headshot_extension_vet_b_zea_a_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_a"
				}
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_seen_headshot",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_headshot_replier",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_headshot_extension_vet_b_zea_a_d",
		wwise_route = 0,
		response = "bonding_conversation_headshot_extension_vet_b_zea_a_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_headshot_extension_vet_b_zea_a_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_headshot_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_17_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_17_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				3
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_17_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.TIMEDIFF,
				OP.LT,
				60
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_17_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_17_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_17_b",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_17_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_17_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_c"
				}
			},
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMEDIFF,
				OP.LT,
				75
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_heavy_injury_17_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_17_c",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_17_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_17_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_17_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_17_d",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_17_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_17_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_17_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_18_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_18_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				3
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_18_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.TIMEDIFF,
				OP.LT,
				60
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_18_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_18_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_18_b",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_18_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_18_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_c"
				}
			},
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMEDIFF,
				OP.LT,
				75
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_heavy_injury_18_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_18_c",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_18_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_18_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_18_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_18_d",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_18_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_18_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_18_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_19_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_19_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				3
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_19_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.TIMEDIFF,
				OP.LT,
				60
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_19_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_19_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_19_b",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_19_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_19_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_c"
				}
			},
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMEDIFF,
				OP.LT,
				75
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_heavy_injury_19_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_19_c",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_19_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_19_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_19_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_19_d",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_19_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_19_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_19_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_20_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_20_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				3
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_c"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_20_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.TIMEDIFF,
				OP.LT,
				60
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_20_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_20_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_20_b",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_20_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_20_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_c"
				}
			},
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMEDIFF,
				OP.LT,
				75
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_heavy_injury_20_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_20_c",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_20_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_20_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_20_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_20_d",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_20_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_20_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_c"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_20_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_37_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_37_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				3
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_37_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.TIMEDIFF,
				OP.LT,
				60
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_37_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_37_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_37_b",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_37_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_37_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b"
				}
			},
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMEDIFF,
				OP.LT,
				75
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_heavy_injury_37_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_37_c",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_37_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_37_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_37_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_37_d",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_37_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_37_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_37_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_38_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_38_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				3
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_38_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.TIMEDIFF,
				OP.LT,
				60
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_38_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_38_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_38_b",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_38_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_38_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b"
				}
			},
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMEDIFF,
				OP.LT,
				75
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_heavy_injury_38_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_38_c",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_38_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_38_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_38_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_38_d",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_38_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_38_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_38_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_39_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_39_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				3
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_39_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.TIMEDIFF,
				OP.LT,
				60
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_39_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_39_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_39_b",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_39_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_39_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b"
				}
			},
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMEDIFF,
				OP.LT,
				75
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_heavy_injury_39_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_39_c",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_39_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_39_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_39_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_39_d",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_39_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_39_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_39_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_40_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_40_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				3
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_40_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.TIMEDIFF,
				OP.LT,
				60
			},
			{
				"user_memory",
				"last_seen_veteran_losing_health",
				OP.GT,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_heavy_injury_40_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_40_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_40_b",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_40_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_40_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b"
				}
			},
			{
				"user_memory",
				"last_rapid_loosing_health",
				OP.TIMEDIFF,
				OP.LT,
				75
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_heavy_injury_40_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_40_c",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_40_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_40_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_40_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_heavy_injury_40_d",
		wwise_route = 0,
		response = "bonding_conversation_heavy_injury_40_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_heavy_injury_40_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_heavy_injury_40_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_b_ogr_a_c",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_b_ogr_a_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_ogryn_a__response_for_veteran_seen_killstreak_ogryn_01",
					"loc_ogryn_a__response_for_veteran_seen_killstreak_ogryn_02",
					"loc_ogryn_a__response_for_veteran_seen_killstreak_ogryn_03",
					"loc_ogryn_a__response_for_veteran_seen_killstreak_ogryn_04",
					"loc_ogryn_a__response_for_veteran_seen_killstreak_ogryn_05"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_killstreak_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_b_ogr_a_d",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_b_ogr_a_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_killstreak_extension_vet_b_ogr_a_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {
			{
				"user_memory",
				"killstreak_extension_vet_b_ogr_a_d",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_b_ogr_a_e",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_b_ogr_a_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_killstreak_extension_vet_b_ogr_a_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_killstreak_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_b_ogr_a_f",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_b_ogr_a_f",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_killstreak_extension_vet_b_ogr_a_e"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			},
			{
				"user_memory",
				"killstreak_extension_vet_b_ogr_a_d",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_b_psy_a_c",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_b_psy_a_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_psyker_male_a__response_for_veteran_seen_killstreak_psyker_01",
					"loc_psyker_male_a__response_for_veteran_seen_killstreak_psyker_02",
					"loc_psyker_male_a__response_for_veteran_seen_killstreak_psyker_03",
					"loc_psyker_male_a__response_for_veteran_seen_killstreak_psyker_04",
					"loc_psyker_male_a__response_for_veteran_seen_killstreak_psyker_05"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_killstreak_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_b_psy_a_d",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_b_psy_a_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_killstreak_extension_vet_b_psy_a_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_a"
				}
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_b_vet_c_c",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_b_vet_c_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_veteran_female_c__response_for_veteran_seen_killstreak_veteran_01",
					"loc_veteran_female_c__response_for_veteran_seen_killstreak_veteran_02",
					"loc_veteran_female_c__response_for_veteran_seen_killstreak_veteran_03",
					"loc_veteran_female_c__response_for_veteran_seen_killstreak_veteran_04",
					"loc_veteran_female_c__response_for_veteran_seen_killstreak_veteran_05"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_killstreak_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_b_vet_c_d",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_b_vet_c_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_killstreak_extension_vet_b_vet_c_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_c"
				}
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_b_vet_c_e",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_b_vet_c_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_killstreak_extension_vet_b_vet_c_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_killstreak_user",
				OP.EQ,
				OP.LT,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_b_zea_c_c",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_b_zea_c_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_zealot_male_c__response_for_veteran_seen_killstreak_zealot_01",
					"loc_zealot_male_c__response_for_veteran_seen_killstreak_zealot_02",
					"loc_zealot_male_c__response_for_veteran_seen_killstreak_zealot_03",
					"loc_zealot_male_c__response_for_veteran_seen_killstreak_zealot_04",
					"loc_zealot_male_c__response_for_veteran_seen_killstreak_zealot_05"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.TIMEDIFF,
				OP.LT,
				10
			},
			{
				"user_memory",
				"last_seen_killstreak_user",
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_killstreak_extension",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_killstreak_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			},
			random_ignore_vo = {
				chance = 0.1,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_killstreak_extension_vet_b_zea_c_d",
		wwise_route = 0,
		response = "bonding_conversation_killstreak_extension_vet_b_zea_c_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_killstreak_extension_vet_b_zea_c_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"last_killstreak",
				OP.GT,
				1
			},
			{
				"user_memory",
				"last_killstreak",
				OP.TIMEDIFF,
				OP.LT,
				10
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_bottle_a",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_bottle_a",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_ogryn_d__lore_morrow_four_c_02",
					"loc_ogryn_d__lore_morrow_two_c_01",
					"loc_ogryn_d__lore_rannick_one_c_02",
					"loc_ogryn_d__lore_rannick_four_c_02",
					"loc_ogryn_d__lore_grendyl_two_c_02"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_bottle_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_bottle_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_bottle_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_bottle_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_bottle_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_bottle_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_bottle_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_bottle_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_bottle_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_bottle_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_bottle_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_bottle_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_bottle_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_bottle_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_bottle_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_bottle_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_bottle_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_bottle_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_bottle_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_bottle_f",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_bottle_f",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_bottle_e"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_bottle_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_come_play_a",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_come_play_a",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_come_play_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_come_play_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_come_play_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.4,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_come_play_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_come_play_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_come_play_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_come_play_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_come_play_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_come_play_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_come_play_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_come_play_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_come_play_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_come_play_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_come_play_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_come_play_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_come_play_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_come_play_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_come_play_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_come_play_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_come_play_f",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_come_play_f",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_come_play_e"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_come_play_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_commissar_a",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_commissar_a",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_veteran_male_a__combat_pause_one_liner_04",
					"loc_veteran_male_a__combat_pause_quirk_weapons_b_01",
					"loc_veteran_male_a__combat_pause_quirk_ogryn_a_bigger_gun_b_02",
					"loc_veteran_male_a__combat_pause_limited_veteran_a_03_b_01",
					"loc_veteran_male_a__combat_pause_limited_veteran_a_17_b_01",
					"loc_veteran_male_a__combat_pause_limited_psyker_c_18_b_01"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_commissar_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_commissar_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_commissar_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_commissar_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_commissar_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_commissar_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_commissar_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_commissar_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_commissar_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_commissar_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_commissar_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_commissar_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_commissar_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_commissar_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_commissar_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_commissar_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_commissar_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_commissar_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_commissar_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_commissar_f",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_commissar_f",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_commissar_e"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_commissar_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_corpse_starch_vet_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_corpse_starch_vet_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_d"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_corpse_starch_vet_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_corpse_starch_vet_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_corpse_starch_vet_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_corpse_starch_vet_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_corpse_starch_vet_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_corpse_starch_vet_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_corpse_starch_vet_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_corpse_starch_vet_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_corpse_starch_vet_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_corpse_starch_vet_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_corpse_starch_vet_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_corpse_starch_vet_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_corpse_starch_vet_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_corpse_starch_vet_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_corpse_starch_vet_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_cosy_soul_a",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_cosy_soul_a",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_psyker_male_b__combat_pause_one_liner_02",
					"loc_psyker_male_b__combat_pause_one_liner_04",
					"loc_psyker_male_b__combat_pause_quirk_emperor_b_02",
					"loc_psyker_male_b__combat_pause_quirk_accuracy_b_02",
					"loc_psyker_male_b__combat_pause_quirk_puny_b_02",
					"loc_psyker_male_b__combat_pause_limited_ogryn_c_17_b_01"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_cosy_soul_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_cosy_soul_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_cosy_soul_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_cosy_soul_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_cosy_soul_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_cosy_soul_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_cosy_soul_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_cosy_soul_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_cosy_soul_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_cosy_soul_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_cosy_soul_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_cosy_soul_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_cosy_soul_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_cosy_soul_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_cosy_soul_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_cosy_soul_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_cosy_soul_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_cosy_soul_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_cosy_soul_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_cosy_soul_f",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_cosy_soul_f",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_cosy_soul_e"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_cosy_soul_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_death_smells_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_death_smells_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_d"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_death_smells_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_death_smells_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_death_smells_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_death_smells_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_death_smells_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_death_smells_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_death_smells_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_death_smells_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_death_smells_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_death_smells_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_death_smells_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_death_smells_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_death_smells_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_death_smells_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_death_smells_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_dedicated_beloved_a",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_dedicated_beloved_a",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_psyker_male_b__combat_pause_quirk_trust_b_01",
					"loc_psyker_male_b__combat_pause_one_liner_01",
					"loc_psyker_male_b__combat_pause_quirk_turncoat_b_01",
					"loc_psyker_male_b__combat_pause_quirk_emperor_b_02",
					"loc_psyker_male_b__combat_pause_limited_zealot_c_02_b_01",
					"loc_psyker_male_b__combat_pause_quirk_competence_b_01"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_dedicated_beloved_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_dedicated_beloved_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_dedicated_beloved_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_dedicated_beloved_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_dedicated_beloved_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_dedicated_beloved_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_dedicated_beloved_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_dedicated_beloved_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_dedicated_beloved_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_dedicated_beloved_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_dedicated_beloved_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_dedicated_beloved_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_dedicated_beloved_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_dedicated_beloved_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_dedicated_beloved_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_dedicated_beloved_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_dedicated_beloved_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_dedicated_beloved_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_dedicated_beloved_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_dedicated_beloved_f",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_dedicated_beloved_f",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_dedicated_beloved_e"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_dedicated_beloved_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_eyeballs_a",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_eyeballs_a",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_psyker_male_b__combat_pause_one_liner_04",
					"loc_psyker_male_b__combat_pause_one_liner_06",
					"loc_psyker_male_b__combat_pause_limited_zealot_a_02_b_01",
					"loc_psyker_male_b__combat_pause_limited_psyker_b_10_b_01",
					"loc_psyker_male_b__combat_pause_limited_veteran_b_11_b_01",
					"loc_psyker_male_b__lore_zola_one_c_01"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_eyeballs_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_eyeballs_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_eyeballs_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_eyeballs_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_eyeballs_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_eyeballs_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_eyeballs_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_eyeballs_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_eyeballs_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_eyeballs_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_eyeballs_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_eyeballs_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_eyeballs_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_eyeballs_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_eyeballs_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_homesick_a",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_homesick_a",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_homesick_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_homesick_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_homesick_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.4,
				max_failed_tries = 0,
				hold_for = 0
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_homesick_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_homesick_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_homesick_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_homesick_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_homesick_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_homesick_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_homesick_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_homesick_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_homesick_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_homesick_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_homesick_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_homesick_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_in_the_moment_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_in_the_moment_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_in_the_moment_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_in_the_moment_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_in_the_moment_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_in_the_moment_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_in_the_moment_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_in_the_moment_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_in_the_moment_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_in_the_moment_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_in_the_moment_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_in_the_moment_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_in_the_moment_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_lies_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_lies_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_d"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_lies_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_lies_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_lies_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_lies_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_lies_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_lies_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_lies_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_lies_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_lies_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_lies_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_lies_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_lies_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_lies_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_lies_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_lies_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_little_things_a",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_little_things_a",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_psyker_male_b__away_from_squad_01",
					"loc_psyker_male_b__away_from_squad_02",
					"loc_psyker_male_b__away_from_squad_03",
					"loc_psyker_male_b__away_from_squad_04",
					"loc_psyker_male_b__away_from_squad_05",
					"loc_psyker_male_b__away_from_squad_06",
					"loc_psyker_male_b__away_from_squad_07",
					"loc_psyker_male_b__away_from_squad_08",
					"loc_psyker_male_b__away_from_squad_09",
					"loc_psyker_male_b__away_from_squad_10"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_little_things_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"dummy_memory_to_evaluate_above_come_back_to_squad",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"dummy_memory_to_evaluate_above_come_back_to_squad_2",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_little_things_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_little_things_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_little_things_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_little_things_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_little_things_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_little_things_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_little_things_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_little_things_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_little_things_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_little_things_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_little_things_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_little_things_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_little_things_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_little_things_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_point_of_view_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_point_of_view_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_point_of_view_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_point_of_view_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_point_of_view_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_point_of_view_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_point_of_view_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_point_of_view_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_point_of_view_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_point_of_view_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_point_of_view_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_point_of_view_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_point_of_view_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_point_of_view_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_point_of_view_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_point_of_view_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_point_of_view_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_point_of_view_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_point_of_view_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_point_of_view_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_point_of_view_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_point_of_view_f",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_point_of_view_f",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_point_of_view_e"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_point_of_view_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_sides_a",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_sides_a",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_psyker_male_b__combat_pause_one_liner_05",
					"loc_psyker_male_b__lore_chaos_three_c_02",
					"loc_psyker_male_b__lore_chaos_one_c_01",
					"loc_psyker_male_b__lore_chaos_three_c_01",
					"loc_psyker_male_b__lore_chaos_four_c_02"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_sides_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_sides_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_sides_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_sides_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_sides_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_sides_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_sides_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_sides_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_sides_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_sides_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_sides_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_sides_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_sides_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_sides_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_sides_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_smart_ogryn_a",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_smart_ogryn_a",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_ogryn_d__combat_pause_limited_ogryn_a_15_b_02",
					"loc_ogryn_d__lore_astra_militarum_two_c_01",
					"loc_ogryn_d__lore_hive_cities_one_c_01",
					"loc_ogryn_d__lore_hive_cities_two_c_01",
					"loc_ogryn_d__lore_hallowette_two_c_01",
					"loc_ogryn_d__lore_hallowette_two_c_02"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_smart_ogryn_a",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_smart_ogryn_a",
				OP.ADD,
				1
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_smart_ogryn_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_smart_ogryn_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_smart_ogryn_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_smart_ogryn_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_smart_ogryn_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_smart_ogryn_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_smart_ogryn_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_smart_ogryn_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_smart_ogryn_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_smart_ogryn_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_smart_ogryn_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_smart_ogryn_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_smart_ogryn_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_smart_ogryn_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_smart_ogryn_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_smart_ogryn_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_smart_ogryn_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_smart_ogryn_f",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_smart_ogryn_f",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_smart_ogryn_e"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"ogryn_d"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_smart_ogryn_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_soothing_blood_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_soothing_blood_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"team_threat_level",
				OP.SET_INCLUDES,
				args = {
					"low"
				}
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				0
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_soothing_blood_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				220
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_soothing_blood_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMESET
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_soothing_blood_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_soothing_blood_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_soothing_blood_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_soothing_blood_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_soothing_blood_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_soothing_blood_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_soothing_blood_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_soothing_blood_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_soothing_blood_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_soothing_blood_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_soothing_blood_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_soothing_blood_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_soothing_blood_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_soothing_blood_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_soothing_blood_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_soothing_blood_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_soothing_blood_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_trusted_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_trusted_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"veteran_male_a"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_trusted_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_trusted_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_trusted_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_trusted_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_trusted_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_trusted_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_trusted_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_trusted_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_trusted_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_trusted_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_trusted_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_trusted_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_trusted_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_trusted_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_trusted_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_trusted_e",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_trusted_e",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_trusted_d"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_trusted_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_wax_a",
		category = "conversations_prio_1",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_wax_a",
		database = "veteran_female_b",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"short_story_talk"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				0
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				1
			},
			{
				"global_context",
				"level_time",
				OP.GT,
				90
			},
			{
				"global_context",
				"is_decaying_tension",
				OP.EQ,
				"true"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"psyker_male_b"
				}
			},
			{
				"faction_memory",
				"bonding_conversation_metropolitan_wax_a",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMEDIFF,
				OP.GT,
				140
			},
			{
				"faction_memory",
				"time_since_last_conversation",
				OP.TIMEDIFF,
				OP.GT,
				20
			}
		},
		on_done = {
			{
				"faction_memory",
				"bonding_conversation_metropolitan_wax_a",
				OP.ADD,
				1
			},
			{
				"faction_memory",
				"time_since_last_short_conversation",
				OP.TIMESET,
				"0"
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_wax_a_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_wax_b",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_wax_b",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_wax_a"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"bonding_conversation_metropolitan_wax_b_user",
				OP.ADD,
				1
			}
		},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_wax_c",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_wax_c",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_wax_b"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_wax_a_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
	define_rule({
		name = "bonding_conversation_metropolitan_wax_d",
		wwise_route = 0,
		response = "bonding_conversation_metropolitan_wax_d",
		database = "veteran_female_b",
		category = "conversations_prio_1",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak"
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"bonding_conversation_metropolitan_wax_c"
				}
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_b"
				}
			},
			{
				"user_memory",
				"bonding_conversation_metropolitan_wax_b_user",
				OP.EQ,
				1
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "players"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2
			}
		}
	})
end
