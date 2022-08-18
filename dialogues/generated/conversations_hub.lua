return function ()
	define_rule({
		name = "barber_distance",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "barber_distance",
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
				"barber_distance"
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
		name = "barber_goodbye",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "barber_goodbye",
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
				"barber_goodbye"
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
		name = "barber_hello",
		category = "npc_prio_0",
		wwise_route = 0,
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
		name = "barber_purchase",
		category = "npc_prio_0",
		wwise_route = 0,
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
		wwise_route = 0,
		response = "boon_vendor_distance_restocked_dislikes_character",
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
				"boon_vendor_distance_restocked_dislikes_character"
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
		name = "boon_vendor_distance_restocked_likes_character",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "boon_vendor_distance_restocked_likes_character",
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
				"boon_vendor_distance_restocked_likes_character"
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
		name = "boon_vendor_goodbye_dislikes_character",
		category = "npc_prio_0",
		wwise_route = 0,
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
		wwise_route = 0,
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
		wwise_route = 0,
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
		category = "npc_prio_0",
		wwise_route = 0,
		response = "contract_vendor_distance_dislikes_character",
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
				"contract_vendor_distance_likes_character"
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
		name = "contract_vendor_distance_likes_character",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "contract_vendor_distance_likes_character",
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
				"contract_vendor_distance_likes_character"
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
		name = "contract_vendor_goodbye_dislikes_character",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "contract_vendor_goodbye_dislikes_character",
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
				"contract_vendor_goodbye_dislikes_character"
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
		name = "contract_vendor_goodbye_likes_character",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "contract_vendor_goodbye_likes_character",
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
				"contract_vendor_goodbye_likes_character"
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
		name = "contract_vendor_replacing_task",
		category = "npc_prio_0",
		wwise_route = 0,
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
		name = "contract_vendor_setting_contract",
		category = "npc_prio_0",
		wwise_route = 0,
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
		name = "credit_store_servitor_distance_restocked",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "credit_store_servitor_distance_restocked",
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
				"credit_store_servitor_distance_restocked"
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
		name = "credit_store_servitor_goodbye",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "credit_store_servitor_goodbye",
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
				"credit_store_servitor_goodbye"
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
		name = "credit_store_servitor_hello",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "credit_store_servitor_hello",
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
				"credit_store_servitor_hello"
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
		name = "credit_store_servitor_purchase",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "credit_store_servitor_purchase",
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
				"user_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				240
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_last_random_talk",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		post_wwise_event = "play_radio_static_end",
		name = "hub_idle_conversation_eight_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "hub_idle_conversation_eight_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_eight_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_eight_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_eleven_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_eleven_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_eleven_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_eleven_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_fifteen_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_fifteen_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_fifteen_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_fifteen_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_five_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_five_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_five_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_five_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_four_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_four_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_four_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_four_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_fourteen_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_fourteen_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_fourteen_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_fourteen_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_nine_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_nine_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_nine_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_nine_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_one_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_one_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_one_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_one_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_seven_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "hub_idle_conversation_seven_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_seven_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_seven_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_six_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_six_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_six_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 21,
		response = "hub_idle_conversation_six_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_sixteen_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_sixteen_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_sixteen_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_sixteen_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_ten_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_ten_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_ten_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_ten_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_ten_c",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_ten_c",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_thirteen_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_thirteen_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_thirteen_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_thirteen_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_three_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_three_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_three_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_three_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_tweleve_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_tweleve_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_tweleve_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_tweleve_b",
		database = "conversations_hub",
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
		name = "hub_idle_conversation_two_a",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_two_a",
		database = "conversations_hub",
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
				OP.EQ,
				0
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
				OP.ADD,
				1
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
		name = "hub_idle_conversation_two_b",
		pre_wwise_event = "play_radio_static_start",
		wwise_route = 1,
		response = "hub_idle_conversation_two_b",
		database = "conversations_hub",
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
		name = "hub_interact_boon_vendor_dislikes_character",
		category = "npc_prio_0",
		wwise_route = 19,
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
		wwise_route = 19,
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
		wwise_route = 19,
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
		wwise_route = 19,
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
		wwise_route = 19,
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
				"purser_dislikes_character"
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
		wwise_route = 19,
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
				"purser_likes_character"
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
			},
			{
				"user_memory",
				"last_purser_likes_character",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_purser_likes_character",
				OP.TIMESET
			}
		}
	})
	define_rule({
		name = "hub_interact_shipmistress_dislikes_character",
		category = "npc_prio_0",
		wwise_route = 19,
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
		wwise_route = 19,
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
		wwise_route = 19,
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
		wwise_route = 19,
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
		wwise_route = 19,
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
		wwise_route = 19,
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
		category = "npc_prio_0",
		wwise_route = 22,
		response = "hub_mission_board_announcement_dust",
		database = "conversations_hub",
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
				"user_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_mission_update",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_dust_circumstance",
		category = "npc_prio_0",
		wwise_route = 22,
		response = "hub_mission_board_announcement_dust_circumstance",
		database = "conversations_hub",
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
				"user_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_mission_update",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_generic",
		category = "npc_prio_0",
		wwise_route = 22,
		response = "hub_mission_board_announcement_generic",
		database = "conversations_hub",
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
				"user_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_mission_update",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_generic_circumstance",
		category = "npc_prio_0",
		wwise_route = 22,
		response = "hub_mission_board_announcement_generic_circumstance",
		database = "conversations_hub",
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
				"user_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_mission_update",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_tank_foundry",
		category = "npc_prio_0",
		wwise_route = 22,
		response = "hub_mission_board_announcement_tank_foundry",
		database = "conversations_hub",
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
				"user_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_mission_update",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_tank_foundry_circumstance",
		category = "npc_prio_0",
		wwise_route = 22,
		response = "hub_mission_board_announcement_tank_foundry_circumstance",
		database = "conversations_hub",
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
				"user_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_mission_update",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_transit",
		category = "npc_prio_0",
		wwise_route = 22,
		response = "hub_mission_board_announcement_transit",
		database = "conversations_hub",
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
				"user_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_mission_update",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_transit_circumstance",
		category = "npc_prio_0",
		wwise_route = 22,
		response = "hub_mission_board_announcement_transit_circumstance",
		database = "conversations_hub",
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
				"user_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_mission_update",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_watertown",
		category = "npc_prio_0",
		wwise_route = 22,
		response = "hub_mission_board_announcement_watertown",
		database = "conversations_hub",
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
				"user_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_mission_update",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
		}
	})
	define_rule({
		name = "hub_mission_board_announcement_watertown_circumstance",
		category = "npc_prio_0",
		wwise_route = 22,
		response = "hub_mission_board_announcement_watertown_circumstance",
		database = "conversations_hub",
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
				"user_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				30
			}
		},
		on_done = {
			{
				"user_memory",
				"last_mission_update",
				OP.TIMESET
			}
		},
		heard_speak_routing = {
			target = "disabled"
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
				"random_talkk"
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_servitor_d"
				}
			},
			{
				"user_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				240
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_last_random_talk",
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
				"user_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				240
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_last_random_talk",
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
				"user_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				240
			}
		},
		on_done = {
			{
				"user_memory",
				"time_since_last_random_talk",
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
		wwise_route = 0,
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
		name = "npc_first_interaction_contract_vendor",
		category = "conversations_prio_0",
		wwise_route = 19,
		response = "npc_first_interaction_contract_vendor",
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
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
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
		name = "npc_first_interaction_purser",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "npc_first_interaction_purser",
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
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
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
		name = "npc_first_interaction_shipmistress",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "npc_first_interaction_shipmistress",
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
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
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
		name = "npc_first_interaction_training_ground_psyker",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "npc_first_interaction_training_ground_psyker",
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
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
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
		name = "npc_first_interaction_underhive_contact",
		category = "conversations_prio_0",
		wwise_route = 0,
		response = "npc_first_interaction_underhive_contact",
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
				"user_context",
				"is_knocked_down",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_ledge_hanging",
				OP.EQ,
				"false"
			},
			{
				"user_context",
				"is_pounced_down",
				OP.EQ,
				"false"
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
		name = "pilot_distance",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "pilot_distance",
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
		name = "purser_goodbye_dislikes_character",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "purser_goodbye_dislikes_character",
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
				"purser_goodbye_dislikes_character"
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
		name = "purser_goodbye_likes_character",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "purser_goodbye_likes_character",
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
				"purser_goodbye_likes_character"
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
		name = "purser_purchase",
		category = "npc_prio_0",
		wwise_route = 0,
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
		category = "npc_prio_0",
		wwise_route = 0,
		response = "tech_priest_distance",
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
				"tech_priest_distance"
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
		name = "tech_priest_goodbye",
		category = "npc_prio_0",
		wwise_route = 0,
		response = "tech_priest_goodbye",
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
