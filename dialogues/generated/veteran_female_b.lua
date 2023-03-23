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
end
