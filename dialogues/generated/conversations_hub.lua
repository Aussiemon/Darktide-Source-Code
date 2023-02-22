return function ()
	define_rule({
		name = "barber_distance",
		category = "npc_prio_0",
		response = "barber_distance",
		database = "conversations_hub",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_distance"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"barber"
				}
			},
			{
				"user_memory",
				"barber_goodbye",
				OP.EQ,
				0
			},
			{
				"user_memory",
				"barber_distance",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"barber_distance",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "barber_goodbye",
		category = "npc_prio_0",
		response = "barber_goodbye",
		database = "conversations_hub",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_goodbye"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"barber"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "barber_hello",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "barber_hello",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_hello"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "barber_intro_a",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "barber_intro_a",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_intro_a"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "barber_intro_b",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "barber_intro_b",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_intro_b"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "barber_intro_c",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "barber_intro_c",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_intro_c"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "barber_intro_d",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "barber_intro_d",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_intro_d"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "barber_purchase",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "barber_purchase",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_purchase"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "boon_vendor_distance_restocked_dislikes_character",
		category = "npc_prio_0",
		response = "boon_vendor_distance_restocked_dislikes_character",
		database = "conversations_hub",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_distance_restocked_dislikes_character"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"psyker_male_a",
					"psyker_female_a",
					"ogryn_b",
					"veteran_male_b",
					"veteran_female_b",
					"psyker_male_b",
					"psyker_female_b",
					"veteran_male_c",
					"veteran_female_c",
					"psyker_male_c",
					"psyker_female_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"last_boon_vendor_distant",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_boon_vendor_distant",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "boon_vendor_distance_restocked_likes_character",
		category = "npc_prio_0",
		response = "boon_vendor_distance_restocked_likes_character",
		database = "conversations_hub",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_distance_restocked_likes_character"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"veteran_male_a",
					"veteran_female_a",
					"zealot_male_a",
					"zealot_female_a",
					"zealot_male_b",
					"zealot_female_b",
					"ogryn_c",
					"zealot_male_c",
					"zealot_female_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"last_boon_vendor_distant",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_boon_vendor_distant",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "boon_vendor_goodbye_dislikes_character",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "boon_vendor_goodbye_dislikes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_goodbye_dislikes_character"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "boon_vendor_goodbye_likes_character",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "boon_vendor_goodbye_likes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_goodbye_likes_character"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "boon_vendor_purchase",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "boon_vendor_purchase",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_purchase"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "confessional_vo_news_bulletin",
		category = "vox_prio_0",
		wwise_route = 19,
		response = "confessional_vo_news_bulletin",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"confessional_vo"
			},
			{
				"query_context",
				"category",
				OP.EQ,
				"news_bulletin"
			}
		},
		on_done = {}
	})
	define_rule({
		name = "confessional_vo_report_alert",
		category = "vox_prio_0",
		wwise_route = 19,
		response = "confessional_vo_report_alert",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"confessional_vo"
			},
			{
				"query_context",
				"category",
				OP.EQ,
				"report_alert"
			}
		},
		on_done = {}
	})
	define_rule({
		name = "confessional_vo_sermon",
		category = "vox_prio_0",
		wwise_route = 19,
		response = "confessional_vo_sermon",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"confessional_vo"
			},
			{
				"query_context",
				"category",
				OP.EQ,
				"sermon"
			}
		},
		on_done = {}
	})
	define_rule({
		name = "contract_vendor_distance_dislikes_character",
		wwise_route = 19,
		response = "contract_vendor_distance_dislikes_character",
		database = "conversations_hub",
		category = "npc_prio_0",
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_distance"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"veteran_male_b",
					"veteran_female_b",
					"zealot_male_b",
					"zealot_female_b",
					"psyker_male_b",
					"psyker_female_b",
					"veteran_male_c",
					"veteran_female_c",
					"zealot_male_c",
					"zealot_female_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "contract_vendor_distance_likes_character",
		wwise_route = 19,
		response = "contract_vendor_distance_likes_character",
		database = "conversations_hub",
		category = "npc_prio_0",
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_distance"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a",
					"veteran_female_a",
					"zealot_male_a",
					"zealot_female_a",
					"psyker_male_a",
					"psyker_female_a",
					"ogryn_c",
					"psyker_male_c",
					"psyker_female_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "contract_vendor_goodbye_dislikes_character",
		category = "npc_prio_0",
		response = "contract_vendor_goodbye_dislikes_character",
		database = "conversations_hub",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_goodbye"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"veteran_male_b",
					"veteran_female_b",
					"zealot_male_b",
					"zealot_female_b",
					"psyker_male_b",
					"psyker_female_b",
					"veteran_male_c",
					"veteran_female_c",
					"zealot_male_c",
					"zealot_female_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "contract_vendor_goodbye_likes_character",
		category = "npc_prio_0",
		response = "contract_vendor_goodbye_likes_character",
		database = "conversations_hub",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_goodbye"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a",
					"veteran_female_a",
					"zealot_male_a",
					"zealot_female_a",
					"psyker_male_a",
					"psyker_female_a",
					"ogryn_c",
					"psyker_male_c",
					"psyker_female_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "contract_vendor_purchase_a",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "contract_vendor_purchase_a",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_purchase_a"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "contract_vendor_replacing_task",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "contract_vendor_replacing_task",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_replacing_task"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "contract_vendor_servitor_purchase_b",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "contract_vendor_servitor_purchase_b",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_servitor_purchase_b"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "contract_vendor_setting_contract",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "contract_vendor_setting_contract",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_setting_contract"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "crafting_complete",
		wwise_route = 40,
		response = "crafting_complete",
		database = "conversations_hub",
		category = "npc_prio_0",
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"crafting_complete"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"veteran_male_b",
					"veteran_female_b",
					"zealot_male_b",
					"zealot_female_b",
					"psyker_male_b",
					"psyker_female_b",
					"psyker_male_c",
					"psyker_female_c",
					"veteran_male_a",
					"veteran_female_a",
					"zealot_male_a",
					"zealot_female_a",
					"psyker_male_a",
					"psyker_female_a",
					"ogryn_c",
					"veteran_male_c",
					"veteran_female_c",
					"zealot_male_c",
					"zealot_female_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"last_contract_vendor_distant",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_contract_vendor_distant",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		name = "crafting_interact",
		wwise_route = 40,
		response = "crafting_interact",
		database = "conversations_hub",
		category = "npc_prio_0",
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"crafting_interact"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"veteran_male_b",
					"veteran_female_b",
					"zealot_male_b",
					"zealot_female_b",
					"psyker_male_b",
					"psyker_female_b",
					"psyker_male_c",
					"psyker_female_c",
					"veteran_male_a",
					"veteran_female_a",
					"zealot_male_a",
					"zealot_female_a",
					"psyker_male_a",
					"psyker_female_a",
					"ogryn_c",
					"veteran_male_c",
					"veteran_female_c",
					"zealot_male_c",
					"zealot_female_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"last_contract_vendor_distant",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_contract_vendor_distant",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		name = "credit_store_servitor_distance_restocked_b",
		category = "npc_prio_0",
		response = "credit_store_servitor_distance_restocked_b",
		database = "conversations_hub",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_distance_restocked_b"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"credit_store_servitor"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"credit_store_servitor_goodbye_b",
				OP.EQ,
				0
			},
			{
				"faction_memory",
				"credit_store_servitor_distance_restocked_b",
				OP.EQ,
				0
			}
		},
		on_done = {
			{
				"user_memory",
				"credit_store_servitor_distance_restocked_b",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "credit_store_servitor_distance_restocked_c",
		category = "npc_prio_0",
		response = "credit_store_servitor_distance_restocked_c",
		database = "conversations_hub",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_distance_restocked"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"credit_store_servitor"
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "credit_store_servitor_goodbye_b",
		category = "npc_prio_0",
		response = "credit_store_servitor_goodbye_b",
		database = "conversations_hub",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_goodbye_b"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"credit_store_servitor"
				}
			}
		},
		on_done = {
			{
				"user_memory",
				"credit_store_servitor_goodbye_b",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "credit_store_servitor_hello_b",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "credit_store_servitor_hello_b",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_hello_b"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"credit_store_servitor"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "credit_store_servitor_purchase_b",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "credit_store_servitor_purchase_b",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_purchase_b"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "credit_store_servitor_purchase_c",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "credit_store_servitor_purchase_c",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_purchase"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "explicator_distance",
		concurrent_wwise_event = "play_vox_static_loop",
		wwise_route = 19,
		response = "explicator_distance",
		database = "conversations_hub",
		category = "npc_prio_0",
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"explicator_distance"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"veteran_male_b",
					"veteran_female_b",
					"zealot_male_b",
					"zealot_female_b",
					"psyker_male_b",
					"psyker_female_b",
					"veteran_male_c",
					"veteran_female_c",
					"zealot_male_c",
					"zealot_female_c",
					"veteran_male_a",
					"veteran_female_a",
					"zealot_male_a",
					"zealot_female_a",
					"psyker_male_a",
					"psyker_female_a",
					"ogryn_c",
					"psyker_male_c",
					"psyker_female_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "hub_flight_deck_announcement",
		category = "conversations_prio_0",
		wwise_route = 22,
		response = "hub_flight_deck_announcement",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"random_talk"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_servitor_a"
				}
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				139
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				329
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				15
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMESET
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_idle",
		wwise_route = 19,
		response = "hub_idle",
		database = "conversations_hub",
		category = "npc_prio_0",
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_idle"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"veteran_male_b",
					"veteran_female_b",
					"zealot_male_b",
					"zealot_female_b",
					"psyker_male_b",
					"psyker_female_b",
					"psyker_male_c",
					"psyker_female_c",
					"veteran_male_a",
					"veteran_female_a",
					"zealot_male_a",
					"zealot_female_a",
					"psyker_male_a",
					"psyker_female_a",
					"ogryn_c",
					"veteran_male_c",
					"veteran_female_c",
					"zealot_male_c",
					"zealot_female_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"user_memory",
				"last_contract_vendor_distant",
				OP.TIMEDIFF,
				OP.GT,
				1
			}
		},
		on_done = {
			{
				"user_memory",
				"last_contract_vendor_distant",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_eight_a",
		response = "hub_idle_conversation_eight_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_eight_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_eight_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_eight_b",
		response = "hub_idle_conversation_eight_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_eight_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_eleven_a",
		response = "hub_idle_conversation_eleven_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"explicator"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_eleven_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_eleven_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_eleven_b",
		response = "hub_idle_conversation_eleven_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_eleven_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_fifteen_a",
		response = "hub_idle_conversation_fifteen_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"hub_idle_conversation_fifteen_a"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_fifteen_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_fifteen_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_fifteen_b",
		response = "hub_idle_conversation_fifteen_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_fifteen_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_five_a",
		response = "hub_idle_conversation_five_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"sergeant"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_five_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_five_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_five_b",
		response = "hub_idle_conversation_five_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_five_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_four_a",
		response = "hub_idle_conversation_four_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"sergeant"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_four_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_four_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_four_b",
		response = "hub_idle_conversation_four_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_four_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_fourteen_a",
		response = "hub_idle_conversation_fourteen_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"explicator"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_fourteen_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_fourteen_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_fourteen_b",
		response = "hub_idle_conversation_fourteen_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_fourteen_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_nine_a",
		response = "hub_idle_conversation_nine_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"hub_idle_conversation_nine_a"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_nine_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_nine_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_nine_b",
		response = "hub_idle_conversation_nine_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_nine_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_one_a",
		response = "hub_idle_conversation_one_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"sergeant"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_one_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_one_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_one_b",
		response = "hub_idle_conversation_one_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_one_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
					"pilot"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_seven_a",
		response = "hub_idle_conversation_seven_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"tech_priest"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_seven_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_seven_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_seven_b",
		response = "hub_idle_conversation_seven_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_seven_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_six_a",
		response = "hub_idle_conversation_six_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"sergeant"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_six_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_six_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_six_b",
		response = "hub_idle_conversation_six_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_six_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_sixteen_a",
		response = "hub_idle_conversation_sixteen_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"pilot"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_sixteen_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_sixteen_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_sixteen_b",
		response = "hub_idle_conversation_sixteen_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_sixteen_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_ten_a",
		response = "hub_idle_conversation_ten_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"sergeant"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_ten_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_ten_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_ten_b",
		response = "hub_idle_conversation_ten_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_ten_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_ten_c",
		response = "hub_idle_conversation_ten_c",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_ten_b"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_thirteen_a",
		response = "hub_idle_conversation_thirteen_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"explicator"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_thirteen_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_thirteen_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_thirteen_b",
		response = "hub_idle_conversation_thirteen_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_thirteen_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_thirteen_c",
		response = "hub_idle_conversation_thirteen_c",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_thirteen_b"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_three_a",
		response = "hub_idle_conversation_three_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
				"vox_story_talk"
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
				"hub_idle_conversation_three_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_three_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_three_b",
		response = "hub_idle_conversation_three_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_three_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_tweleve_a",
		response = "hub_idle_conversation_tweleve_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"explicator"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_tweleve_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_tweleve_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_tweleve_b",
		response = "hub_idle_conversation_tweleve_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_tweleve_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant"
				}
			}
		},
		on_done = {},
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
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_two_a",
		response = "hub_idle_conversation_two_a",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk"
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
					"sergeant"
				}
			},
			{
				"faction_memory",
				"hub_idle_conversation_two_a",
				OP.TIMEDIFF,
				OP.GT,
				4800
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120
			}
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_conversation_two_a",
				OP.TIMESET
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		pre_wwise_event = "play_radio_static_start",
		name = "hub_idle_conversation_two_b",
		response = "hub_idle_conversation_two_b",
		database = "conversations_hub",
		wwise_route = 1,
		category = "conversations_prio_0",
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
					"hub_idle_conversation_two_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot"
				}
			}
		},
		on_done = {},
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
		name = "hub_idle_crafting",
		wwise_route = 19,
		response = "hub_idle_crafting",
		database = "conversations_hub",
		category = "npc_prio_0",
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_idle_crafting"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"veteran_male_b",
					"veteran_female_b",
					"zealot_male_b",
					"zealot_female_b",
					"psyker_male_b",
					"psyker_female_b",
					"psyker_male_c",
					"psyker_female_c",
					"veteran_male_a",
					"veteran_female_a",
					"zealot_male_a",
					"zealot_female_a",
					"psyker_male_a",
					"psyker_female_a",
					"ogryn_c",
					"veteran_male_c",
					"veteran_female_c",
					"zealot_male_c",
					"zealot_female_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "all"
		}
	})
	define_rule({
		name = "hub_idle_greeting_dislike_a",
		wwise_route = 19,
		response = "hub_idle_greeting_dislike_a",
		database = "conversations_hub",
		category = "npc_prio_0",
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_idle_greeting_crew"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier"
				}
			},
			{
				"query_context",
				"player_level_string",
				OP.SET_INCLUDES,
				args = {
					"2",
					"3",
					"4",
					"5",
					"6",
					"7",
					"8",
					"9",
					"10",
					"11"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_idle_greeting_like_a",
		wwise_route = 19,
		response = "hub_idle_greeting_like_a",
		database = "conversations_hub",
		category = "npc_prio_0",
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_idle_greeting_crew"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier"
				}
			},
			{
				"query_context",
				"player_level_string",
				OP.SET_INCLUDES,
				args = {
					"26",
					"27",
					"28",
					"29",
					"30"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_idle_greeting_neutral_a",
		wwise_route = 19,
		response = "hub_idle_greeting_neutral_a",
		database = "conversations_hub",
		category = "npc_prio_0",
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_idle_greeting_crew"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier"
				}
			},
			{
				"query_context",
				"player_level_string",
				OP.SET_INCLUDES,
				args = {
					"12",
					"13",
					"14",
					"15",
					"16",
					"17",
					"18",
					"19",
					"20",
					"21",
					"22",
					"23",
					"24",
					"25"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_interact_boon_vendor_dislikes_character",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "hub_interact_boon_vendor_dislikes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_dislikes_character"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
					"psyker_male_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor"
				}
			},
			{
				"user_memory",
				"last_boon_vendor_dislikes_character",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_boon_vendor_dislikes_character",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "hub_interact_boon_vendor_likes_character",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "hub_interact_boon_vendor_likes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_likes_character"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"veteran_female_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor"
				}
			},
			{
				"user_memory",
				"last_boon_vendor_likes_character",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_boon_vendor_likes_character",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "hub_interact_contract_vendor_dislikes_character",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "hub_interact_contract_vendor_dislikes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_interaction"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			},
			{
				"user_memory",
				"last_contract_vendor_dislikes_character",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_contract_vendor_dislikes_character",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "hub_interact_contract_vendor_likes_character",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "hub_interact_contract_vendor_likes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_interaction"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			},
			{
				"user_memory",
				"last_contract_vendor_likes_character",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_contract_vendor_likes_character",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "hub_interact_purser_dislikes_character",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "hub_interact_purser_dislikes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_interact_purser_dislikes_character"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
				}
			},
			{
				"user_memory",
				"last_purser_dislikes_character",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_purser_dislikes_character",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "hub_interact_purser_likes_character",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "hub_interact_purser_likes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_interact_purser_likes_character"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "hub_interact_shipmistress_dislikes_character",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "hub_interact_shipmistress_dislikes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"shipmistress_dislikes_character"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"low_level"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress"
				}
			},
			{
				"user_memory",
				"last_shipmistress_dislikes_character",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_shipmistress_dislikes_character",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "hub_interact_shipmistress_likes_character",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "hub_interact_shipmistress_likes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"shipmistress_likes_character"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"high_level"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress"
				}
			},
			{
				"user_memory",
				"last_shipmistress_likes_character",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_shipmistress_likes_character",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "hub_interact_training_ground_psyker_dislikes_character",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "hub_interact_training_ground_psyker_dislikes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"training_ground_psyker_dislikes_character"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a"
				}
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
				"last_training_ground_psyker_dislikes_character",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_training_ground_psyker_dislikes_character",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "hub_interact_training_ground_psyker_likes_character",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "hub_interact_training_ground_psyker_likes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"training_ground_psyker_likes_character"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
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
				"last_training_ground_psyker_likes_character",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_training_ground_psyker_likes_character",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "hub_interact_underhive_contact_dislikes_character",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "hub_interact_underhive_contact_dislikes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_dislikes_character"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"zealot_female_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor"
				}
			},
			{
				"user_memory",
				"last_contract_vendor_dislikes_character",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_contract_vendor_dislikes_character",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "hub_interact_underhive_contact_likes_character",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "hub_interact_underhive_contact_likes_character",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"underhive_contact_likes_character"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"underhive_contact"
				}
			},
			{
				"user_memory",
				"last_underhive_contact_likes_character",
				OP.TIMEDIFF,
				OP.GT,
				5
			}
		},
		on_done = {
			{
				"user_memory",
				"last_underhive_contact_likes_character",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_dust",
		wwise_route = 22,
		response = "hub_mission_board_announcement_dust",
		database = "conversations_hub",
		category = "npc_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update"
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"dm_propaganda",
					"hm_strain",
					"lm_scavenge"
				}
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"false"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor"
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2
			}
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_dust_circumstance",
		wwise_route = 22,
		response = "hub_mission_board_announcement_dust_circumstance",
		database = "conversations_hub",
		category = "npc_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update"
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"dm_propaganda",
					"hm_strain",
					"lm_scavenge"
				}
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"true"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor"
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2
			}
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_generic",
		wwise_route = 22,
		response = "hub_mission_board_announcement_generic",
		database = "conversations_hub",
		category = "npc_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update"
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"fm_resurgence"
				}
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"false"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor"
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2
			}
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_generic_circumstance",
		wwise_route = 22,
		response = "hub_mission_board_announcement_generic_circumstance",
		database = "conversations_hub",
		category = "npc_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update"
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"fm_resurgence"
				}
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"true"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor"
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2
			}
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_tank_foundry",
		wwise_route = 22,
		response = "hub_mission_board_announcement_tank_foundry",
		database = "conversations_hub",
		category = "npc_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update"
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"dm_forge",
					"fm_cargo",
					"lm_cooling"
				}
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"false"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor"
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2
			}
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_tank_foundry_circumstance",
		wwise_route = 22,
		response = "hub_mission_board_announcement_tank_foundry_circumstance",
		database = "conversations_hub",
		category = "npc_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update"
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"dm_forge",
					"fm_cargo",
					"lm_cooling"
				}
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"true"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor"
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2
			}
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_transit",
		wwise_route = 22,
		response = "hub_mission_board_announcement_transit",
		database = "conversations_hub",
		category = "npc_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update"
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"cm_habs",
					"km_station",
					"lm_rails"
				}
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"false"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor"
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2
			}
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_transit_circumstance",
		wwise_route = 22,
		response = "hub_mission_board_announcement_transit_circumstance",
		database = "conversations_hub",
		category = "npc_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update"
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"cm_habs",
					"km_station",
					"lm_rails"
				}
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"true"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor"
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2
			}
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_watertown",
		wwise_route = 22,
		response = "hub_mission_board_announcement_watertown",
		database = "conversations_hub",
		category = "npc_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update"
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"km_enforcer",
					"dm_stockpile",
					"hm_cartel"
				}
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"false"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor"
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2
			}
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_watertown_circumstance",
		wwise_route = 22,
		response = "hub_mission_board_announcement_watertown_circumstance",
		database = "conversations_hub",
		category = "npc_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update"
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"km_enforcer",
					"dm_stockpile",
					"hm_cartel"
				}
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"true"
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor"
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60
			}
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2
			}
		}
	})
	define_rule({
		name = "hub_news_announcement",
		category = "conversations_prio_0",
		wwise_route = 22,
		response = "hub_news_announcement",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"random_talk"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_servitor_c"
				}
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				139
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				329
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				15
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMESET
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_propaganda_announcement",
		category = "conversations_prio_0",
		wwise_route = 22,
		response = "hub_propaganda_announcement",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"random_talk"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"vocator_b"
				}
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				139
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				229
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				15
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMESET
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_status_announcement",
		category = "conversations_prio_0",
		wwise_route = 22,
		response = "hub_status_announcement",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_vo_event"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"random_talk"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_servitor_b"
				}
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				139
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				329
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				15
			}
		},
		on_done = {
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMESET
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "npc_first_interaction_boon_vendor",
		category = "conversations_prio_1",
		wwise_route = 19,
		response = "npc_first_interaction_boon_vendor",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"environmental_story"
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				1
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				4
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				""
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
				"",
				OP.ADD,
				1
			}
		}
	})
	define_rule({
		name = "npc_first_interaction_contract_vendor_a",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "npc_first_interaction_contract_vendor_a",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				""
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "npc_first_interaction_contract_vendor_b",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "npc_first_interaction_contract_vendor_b",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				""
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "npc_first_interaction_contract_vendor_c",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "npc_first_interaction_contract_vendor_c",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				""
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "npc_first_interaction_contract_vendor_d",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "npc_first_interaction_contract_vendor_d",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				""
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "npc_first_interaction_contract_vendor_e",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "npc_first_interaction_contract_vendor_e",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				""
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "npc_first_interaction_purser_a",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "npc_first_interaction_purser_a",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"npc_first_interaction_purser_a"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "npc_first_interaction_purser_b",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "npc_first_interaction_purser_b",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"npc_first_interaction_purser_a"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "npc_first_interaction_purser_c",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "npc_first_interaction_purser_c",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"npc_first_interaction_purser_a"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "npc_first_interaction_purser_d",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "npc_first_interaction_purser_d",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"npc_first_interaction_purser_a"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "npc_first_interaction_purser_e",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "npc_first_interaction_purser_e",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"npc_first_interaction_purser_a"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "npc_first_interaction_shipmistress",
		category = "npc_prio_0",
		wwise_route = 19,
		response = "npc_first_interaction_shipmistress",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				""
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "pilot_distance",
		concurrent_wwise_event = "play_vox_static_loop",
		category = "npc_prio_0",
		response = "pilot_distance",
		database = "conversations_hub",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"pilot_distance"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			}
		},
		on_done = {}
	})
	define_rule({
		pre_wwise_event = "play_radio_static_start",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "prologue_hub_go_mission_board_a",
		wwise_route = 1,
		response = "prologue_hub_go_mission_board_a",
		database = "conversations_hub",
		category = "vox_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info"
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"prologue_hub_go_mission_board_a"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2
			}
		}
	})
	define_rule({
		concurrent_wwise_event = "play_vox_static_loop",
		wwise_route = 1,
		name = "prologue_hub_go_mission_board_b",
		response = "prologue_hub_go_mission_board_b",
		database = "conversations_hub",
		category = "npc_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"prologue_hub_go_mission_board_b"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_male_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_b",
					"zealot_male_b",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		concurrent_wwise_event = "play_vox_static_loop",
		name = "prologue_hub_go_mission_board_c",
		wwise_route = 1,
		response = "prologue_hub_go_mission_board_c",
		database = "conversations_hub",
		category = "npc_prio_0",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"prologue_hub_go_mission_board_c"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_male_a",
					"psyker_female_b",
					"psyker_male_b",
					"psyker_female_c",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_male_a",
					"veteran_female_b",
					"veteran_male_b",
					"veteran_female_c",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_male_a",
					"zealot_female_b",
					"zealot_male_b",
					"zealot_female_c",
					"zealot_male_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator"
				}
			}
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "purser_goodbye_dislikes_character",
		category = "npc_prio_0",
		response = "purser_goodbye_dislikes_character",
		database = "conversations_hub",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"purser_goodbye"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a",
					"veteran_female_a",
					"zealot_male_a",
					"zealot_female_a",
					"psyker_male_a",
					"psyker_female_a",
					"ogryn_c",
					"veteran_male_c",
					"veteran_female_c",
					"zealot_male_c",
					"zealot_female_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "purser_goodbye_likes_character",
		category = "npc_prio_0",
		response = "purser_goodbye_likes_character",
		database = "conversations_hub",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"purser_goodbye"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"veteran_male_b",
					"veteran_female_b",
					"zealot_male_b",
					"zealot_female_b",
					"psyker_male_b",
					"psyker_female_b",
					"psyker_male_c",
					"psyker_female_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser"
				}
			}
		},
		on_done = {}
	})
	define_rule({
		name = "purser_purchase",
		category = "npc_prio_0",
		wwise_route = 40,
		response = "purser_purchase",
		database = "conversations_hub",
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"purser_purchase"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "tech_priest_distance",
		concurrent_wwise_event = "play_vox_static_loop",
		wwise_route = 19,
		response = "tech_priest_distance",
		database = "conversations_hub",
		category = "npc_prio_0",
		speaker_routing = {
			target = "dialogist"
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"tech_priest_distance"
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"psyker_female_a",
					"psyker_female_b",
					"psyker_female_c",
					"psyker_male_a",
					"psyker_male_b",
					"psyker_male_c",
					"veteran_female_a",
					"veteran_female_b",
					"veteran_female_c",
					"veteran_male_a",
					"veteran_male_b",
					"veteran_male_c",
					"zealot_female_a",
					"zealot_female_b",
					"zealot_female_c",
					"zealot_male_a",
					"zealot_male_b",
					"zealot_male_c"
				}
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest"
				}
			},
			{
				"query_context",
				"player_level_string",
				OP.SET_INCLUDES,
				args = {
					""
				}
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "tech_priest_goodbye",
		concurrent_wwise_event = "play_vox_static_loop",
		category = "npc_prio_0",
		response = "tech_priest_goodbye",
		database = "conversations_hub",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo"
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"tech_priest_goodbye"
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					""
				}
			}
		},
		on_done = {}
	})
end
