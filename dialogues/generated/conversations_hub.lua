-- chunkname: @dialogues/generated/conversations_hub.lua

return function ()
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "barber_distance",
		response = "barber_distance",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_distance",
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
					"zealot_male_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"barber",
				},
			},
			{
				"user_memory",
				"barber_goodbye",
				OP.EQ,
				0,
			},
			{
				"user_memory",
				"barber_distance",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"barber_distance",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "barber_goodbye",
		response = "barber_goodbye",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_goodbye",
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
					"zealot_male_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"barber",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "barber_hello",
		response = "barber_hello",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_hello",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "barber_intro_a",
		response = "barber_intro_a",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_intro_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "barber_intro_b",
		response = "barber_intro_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_intro_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "barber_intro_c",
		response = "barber_intro_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_intro_c",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "barber_intro_d",
		response = "barber_intro_d",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_intro_d",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "barber_purchase",
		response = "barber_purchase",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"barber_purchase",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "boon_vendor_distance_restocked_dislikes_character",
		response = "boon_vendor_distance_restocked_dislikes_character",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_distance_restocked_dislikes_character",
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
					"psyker_female_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_boon_vendor_distant",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_boon_vendor_distant",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "boon_vendor_distance_restocked_likes_character",
		response = "boon_vendor_distance_restocked_likes_character",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_distance_restocked_likes_character",
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
					"zealot_female_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_boon_vendor_distant",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_boon_vendor_distant",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "boon_vendor_goodbye_dislikes_character",
		response = "boon_vendor_goodbye_dislikes_character",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_goodbye_dislikes_character",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "boon_vendor_goodbye_likes_character",
		response = "boon_vendor_goodbye_likes_character",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_goodbye_likes_character",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "boon_vendor_purchase",
		response = "boon_vendor_purchase",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_purchase",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_01_b",
		response = "concourse_exchange_01_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_boon_vendor_a__concourse_exchange_01_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_02_b",
		response = "concourse_exchange_02_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_boon_vendor_a__concourse_exchange_02_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_03_b",
		response = "concourse_exchange_03_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_boon_vendor_a__concourse_exchange_03_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_04_b",
		response = "concourse_exchange_04_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_boon_vendor_a__concourse_exchange_04_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_05_b",
		response = "concourse_exchange_05_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_boon_vendor_a__concourse_exchange_05_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_06_b",
		response = "concourse_exchange_06_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_boon_vendor_a__concourse_exchange_06_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_07_b",
		response = "concourse_exchange_07_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_boon_vendor_a__concourse_exchange_07_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_08_b",
		response = "concourse_exchange_08_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_boon_vendor_a__concourse_exchange_08_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_09_b",
		response = "concourse_exchange_09_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_boon_vendor_a__concourse_exchange_09_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_10_b",
		response = "concourse_exchange_10_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_boon_vendor_a__concourse_exchange_10_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_11_b",
		response = "concourse_exchange_11_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_contract_vendor_a__concourse_exchange_11_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_12_b",
		response = "concourse_exchange_12_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_contract_vendor_a__concourse_exchange_12_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_13_b",
		response = "concourse_exchange_13_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_contract_vendor_a__concourse_exchange_13_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_14_b",
		response = "concourse_exchange_14_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_contract_vendor_a__concourse_exchange_14_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_15_b",
		response = "concourse_exchange_15_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_contract_vendor_a__concourse_exchange_15_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_16_b",
		response = "concourse_exchange_16_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_contract_vendor_a__concourse_exchange_16_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_17_b",
		response = "concourse_exchange_17_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_contract_vendor_a__concourse_exchange_17_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_18_b",
		response = "concourse_exchange_18_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_contract_vendor_a__concourse_exchange_18_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_19_b",
		response = "concourse_exchange_19_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_contract_vendor_a__concourse_exchange_19_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_20_b",
		response = "concourse_exchange_20_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_contract_vendor_a__concourse_exchange_20_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_boon_vendor",
		response = "concourse_exchange_boon_vendor",
		wwise_route = 19,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"concourse_exchange_boon_vendor",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
			{
				"faction_memory",
				"concourse_exchange",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				12,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"concourse_exchange",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "concourse_exchange_contract_vendor",
		response = "concourse_exchange_contract_vendor",
		wwise_route = 19,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"concourse_exchange_contract_vendor",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
			{
				"faction_memory",
				"concourse_exchange",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				12,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"concourse_exchange",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "contract_vendor_distance_dislikes_character",
		response = "contract_vendor_distance_dislikes_character",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_distance",
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
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "contract_vendor_distance_likes_character",
		response = "contract_vendor_distance_likes_character",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_distance",
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
					"ogryn_d",
					"psyker_male_c",
					"psyker_female_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "contract_vendor_goodbye_dislikes_character",
		response = "contract_vendor_goodbye_dislikes_character",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_goodbye",
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
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "contract_vendor_goodbye_likes_character",
		response = "contract_vendor_goodbye_likes_character",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_goodbye",
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
					"psyker_female_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "contract_vendor_purchase_a",
		response = "contract_vendor_purchase_a",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_purchase_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "contract_vendor_replacing_task",
		response = "contract_vendor_replacing_task",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_replacing_task",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "contract_vendor_servitor_purchase_b",
		response = "contract_vendor_servitor_purchase_b",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_servitor_purchase_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "contract_vendor_setting_contract",
		response = "contract_vendor_setting_contract",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_setting_contract",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "crafting_complete",
		response = "crafting_complete",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"crafting_complete",
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
					"zealot_female_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"user_memory",
				"last_contract_vendor_distant",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_contract_vendor_distant",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "crafting_interact",
		response = "crafting_interact",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"crafting_interact",
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
					"zealot_female_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"user_memory",
				"last_contract_vendor_distant",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_contract_vendor_distant",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "credit_store_servitor_distance_restocked",
		response = "credit_store_servitor_distance_restocked",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_distance_restocked_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"global_context",
				"player_voice_profiles",
				OP.SET_INTERSECTS,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "credit_store_servitor_distance_restocked_b",
		response = "credit_store_servitor_distance_restocked_b",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_distance_restocked_b",
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
					"zealot_male_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"credit_store_servitor",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"credit_store_servitor_goodbye_b",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"credit_store_servitor_distance_restocked_b",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"credit_store_servitor_distance_restocked_b",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "credit_store_servitor_distance_restocked_c",
		response = "credit_store_servitor_distance_restocked_c",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_distance_restocked",
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
					"zealot_male_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"credit_store_servitor",
				},
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
					"zealot_male_c",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "credit_store_servitor_goodbye",
		response = "credit_store_servitor_goodbye",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_goodbye",
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
					"zealot_male_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"credit_store_servitor",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"credit_store_servitor_goodbye",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "credit_store_servitor_goodbye_b",
		response = "credit_store_servitor_goodbye_b",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_goodbye_b",
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
					"zealot_male_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"credit_store_servitor",
				},
			},
		},
		on_done = {
			{
				"user_memory",
				"credit_store_servitor_goodbye_b",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "credit_store_servitor_hello",
		response = "credit_store_servitor_hello",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "credit_store_servitor_hello_b",
		response = "credit_store_servitor_hello_b",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_hello_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"credit_store_servitor",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "credit_store_servitor_purchase",
		response = "credit_store_servitor_purchase",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_purchase_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "credit_store_servitor_purchase_b",
		response = "credit_store_servitor_purchase_b",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_purchase_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "credit_store_servitor_purchase_c",
		response = "credit_store_servitor_purchase_c",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"credit_store_servitor_purchase",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "explicator_distance",
		response = "explicator_distance",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"explicator_distance",
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
					"psyker_female_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"hammersmith_hub_announcement_01_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hammersmith_hub_announcement_01_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_01_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hammersmith_hub_announcement_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"hammersmith_hub_announcement_02_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hammersmith_hub_announcement_02_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_02_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hammersmith_hub_announcement_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"hammersmith_hub_announcement_03_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hammersmith_hub_announcement_03_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_03_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hammersmith_hub_announcement_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_04_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_04_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"hammersmith_hub_announcement_04_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hammersmith_hub_announcement_04_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_04_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_04_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hammersmith_hub_announcement_04_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_05_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_05_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"hammersmith_hub_announcement_05_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hammersmith_hub_announcement_05_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_05_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_05_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hammersmith_hub_announcement_05_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_06_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_06_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hammersmith_hub_announcement_06_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hammersmith_hub_announcement_06_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_06_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_06_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hammersmith_hub_announcement_06_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_07_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_07_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hammersmith_hub_announcement_07_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hammersmith_hub_announcement_07_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_07_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_07_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hammersmith_hub_announcement_07_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_08_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_08_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hammersmith_hub_announcement_08_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hammersmith_hub_announcement_08_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_08_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_08_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hammersmith_hub_announcement_08_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_09_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_09_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hammersmith_hub_announcement_09_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hammersmith_hub_announcement_09_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_09_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_09_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hammersmith_hub_announcement_09_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_10_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_10_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hammersmith_hub_announcement_10_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hammersmith_hub_announcement_10_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_10_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_10_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hammersmith_hub_announcement_10_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"hammersmith_hub_announcement_a",
				OP.TIMEDIFF,
				OP.GT,
				240,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				100,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hammersmith_hub_announcement_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_a_07_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_a_07_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_interrogator_a__hammersmith_hub_announcement_a_07",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_a_09_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_a_09_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_interrogator_a__hammersmith_hub_announcement_a_09",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hammersmith_hub_announcement_a_19_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hammersmith_hub_announcement_a_19_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_interrogator_a__hammersmith_hub_announcement_a_19",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_announcement_waterloo_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_announcement_waterloo_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
			{
				"faction_memory",
				"hub_announcement_waterloo_01_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_announcement_waterloo_01_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_announcement_waterloo_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_announcement_waterloo_01_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_announcement_waterloo_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enginseer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_announcement_waterloo_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_announcement_waterloo_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enginseer",
				},
			},
			{
				"faction_memory",
				"hub_announcement_waterloo_02_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_announcement_waterloo_02_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_announcement_waterloo_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_announcement_waterloo_02_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_announcement_waterloo_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_announcement_waterloo_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_announcement_waterloo_02_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_announcement_waterloo_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enginseer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_announcement_waterloo_02_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_announcement_waterloo_02_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_announcement_waterloo_02_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_announcement_waterloo_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_announcement_waterloo_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enginseer",
				},
			},
			{
				"faction_memory",
				"hub_announcement_waterloo_03_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_announcement_waterloo_03_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_announcement_waterloo_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_announcement_waterloo_03_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_announcement_waterloo_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_flight_deck_announcement",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_flight_deck_announcement",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"random_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_servitor_a",
				},
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				139,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				329,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMESET,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_greeting_commissar_a",
		response = "hub_greeting_commissar_a",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_greeting_first_interaction_commissar_a",
		response = "hub_greeting_first_interaction_commissar_a",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_greeting_first_interaction_commissar_b",
		response = "hub_greeting_first_interaction_commissar_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_greeting_first_interaction_commissar_c",
		response = "hub_greeting_first_interaction_commissar_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_greeting_first_interaction_commissar_d",
		response = "hub_greeting_first_interaction_commissar_d",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_greeting_live_event_21st_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_greeting_live_event_21st_01_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_greeting_live_event_21st_01_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_greeting_mission_failure_a",
		response = "hub_greeting_mission_failure_a",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_greeting_mission_success_a",
		response = "hub_greeting_mission_success_a",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_greeting_reward_a",
		response = "hub_greeting_reward_a",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_hadron_servitor_idle_mutter_a",
		response = "hub_hadron_servitor_idle_mutter_a",
		wwise_route = 19,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_hadron_servitor_idle_mutter_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_hadron_servitor",
				},
			},
			{
				"faction_memory",
				"crafting_exchange",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				12,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"crafting_exchange",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_hadron_servitor_idle_mutter_b",
		response = "hub_hadron_servitor_idle_mutter_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_hadron_servitor_idle_mutter_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
			random_ignore_vo = {
				chance = 0.7,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_hadron_servitor_idle_mutter_c",
		response = "hub_hadron_servitor_idle_mutter_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_hadron_servitor_idle_mutter_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_hadron_servitor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_idle",
		response = "hub_idle",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_idle",
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
					"zealot_female_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"user_memory",
				"last_contract_vendor_distant",
				OP.TIMEDIFF,
				OP.GT,
				1,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_contract_vendor_distant",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_eighteen_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_eighteen_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_eighteen_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_eighteen_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_eighteen_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_eighteen_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_eighteen_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_eleven_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_eleven_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_eleven_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_eleven_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_eleven_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_eleven_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_eleven_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_fifteen_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_fifteen_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_fifteen_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_fifteen_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_fifteen_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_fifteen_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_fifteen_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_forty_one_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_forty_one_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_forty_one_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_forty_one_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_forty_one_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_forty_one_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_forty_one_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_fortytwo_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_fortytwo_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_fortytwo_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_fortytwo_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_fortytwo_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_fortytwo_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_fortytwo_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_fortytwo_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_fortytwo_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_fortytwo_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_four_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_four_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_four_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_four_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_four_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_four_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_four_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_fourteen_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_fourteen_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_fourteen_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_fourteen_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_fourteen_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_fourteen_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_fourteen_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_nineteen_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_nineteen_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_nineteen_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_nineteen_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_nineteen_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_nineteen_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_nineteen_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_one_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_one_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_one_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_one_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_one_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_one_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_one_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_seven_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_seven_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_seven_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_seven_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_seven_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_seven_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_seven_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_seven_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_seven_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_seven_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_seventeen_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_seventeen_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_seventeen_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_seventeen_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_seventeen_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_seventeen_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_seventeen_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_six_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_six_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_six_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_six_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_six_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_six_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_six_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_six_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_six_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_six_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_sixteen_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_sixteen_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_sixteen_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_sixteen_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_sixteen_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_sixteen_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_sixteen_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_ten_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_ten_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_ten_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_ten_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_ten_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_ten_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_ten_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirteen_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirteen_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirteen_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirteen_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirteen_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirteen_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_thirteen_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirty_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirty_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirty_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirty_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirty_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirty_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_thirty_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtyeight_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtyeight_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtyeight_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtyeight_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtyeight_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtyeight_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_thirtyeight_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtyfive_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtyfive_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtyfive_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtyfive_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtyfive_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtyfive_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_thirtyfive_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtyfour_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtyfour_a",
		wwise_route = 1,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtyfour_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtyfour_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtyfour_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtyfour_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_thirtyfour_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtynine_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtynine_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtynine_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtynine_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtynine_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtynine_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_thirtynine_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtyone_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtyone_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtyone_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtyone_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtyone_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtyone_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_thirtyone_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtyone_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtyone_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_thirtyone_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtyseven_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtyseven_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtyseven_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtyseven_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtyseven_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtyseven_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_thirtyseven_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtysix_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtysix_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtysix_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtysix_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtysix_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtysix_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_thirtysix_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtythree_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtythree_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtythree_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtythree_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtythree_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtythree_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_thirtythree_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtytwo_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtytwo_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtytwo_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_thirtytwo_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_thirtytwo_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_thirtytwo_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_thirtytwo_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_three_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_three_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_three_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_three_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_three_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_three_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_three_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twelve_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twelve_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twelve_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twelve_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twelve_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twelve_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twelve_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twenty_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twenty_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twenty_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twenty_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twenty_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twenty_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twenty_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentyeight_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentyeight_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentyseven_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentyseven_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentyeight_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentyeight_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twentyeight_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentyfive_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentyfive_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentyfive_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentyfive_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentyfive_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentyfive_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twentyfive_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentyfour_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentyfour_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentyfour_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentyfour_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentyfour_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentyfour_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twentyfour_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentynine_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentynine_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentynine_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentynine_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentynine_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentynine_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twentynine_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentynine_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentynine_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twentynine_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentyone_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentyone_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentyone_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentyone_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentyone_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentyone_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twentyone_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentyseven_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentyseven_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentyseven_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentyseven_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentyseven_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentyseven_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twentyseven_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentysix_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentysix_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentysix_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentysix_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentysix_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentysix_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twentysix_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentysixa_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentysixa_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentysixa_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentysixa_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentysixa_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentysixa_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twentysixa_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentythree_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentythree_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentythree_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentythree_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentythree_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentythree_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twentythree_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentythree_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentythree_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twentythree_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentytwo_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentytwo_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentytwo_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_twentytwo_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_twentytwo_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_twentytwo_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_twentytwo_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_two_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_two_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_two_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_idle_2nd_phase_conversation_two_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_idle_2nd_phase_conversation_two_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_idle_2nd_phase_conversation_two_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_idle_2nd_phase_conversation_two_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_idle_crafting",
		response = "hub_idle_crafting",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_idle_crafting",
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
					"zealot_female_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_idle_greeting_dislike_a",
		response = "hub_idle_greeting_dislike_a",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_idle_greeting_crew",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"ogryn_d",
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
					"zealot_male_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
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
					"11",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_idle_greeting_like_a",
		response = "hub_idle_greeting_like_a",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_idle_greeting_crew",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"ogryn_d",
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
					"zealot_male_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
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
					"30",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_idle_greeting_neutral_a",
		response = "hub_idle_greeting_neutral_a",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_idle_greeting_crew",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"ogryn_d",
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
					"zealot_male_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
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
					"25",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "chorus_vo_prio_1",
		database = "conversations_hub",
		name = "hub_idle_oath_01_b",
		response = "hub_idle_oath_01_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress_hub_announcement_a_61_b",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_initial_greeting_live_event_21st_01_a",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_initial_greeting_live_event_21st_01_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_initial_greeting_live_event_21st_01_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_initial_greeting_live_event_21st_01_b",
		post_wwise_event = "play_radio_static_end",
		response = "hub_initial_greeting_live_event_21st_01_b",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_initial_greeting_live_event_21st_01_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_interact_boon_vendor_dislikes_character",
		response = "hub_interact_boon_vendor_dislikes_character",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_dislikes_character",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"psyker_female_a",
					"psyker_male_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
			{
				"user_memory",
				"last_boon_vendor_dislikes_character",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_boon_vendor_dislikes_character",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_interact_boon_vendor_likes_character",
		response = "hub_interact_boon_vendor_likes_character",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"boon_vendor_likes_character",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"veteran_female_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"boon_vendor",
				},
			},
			{
				"user_memory",
				"last_boon_vendor_likes_character",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_boon_vendor_likes_character",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_interact_boon_vendor_rumour_politics_a",
		response = "hub_interact_boon_vendor_rumour_politics_a",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_interact_rumour_politics_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_interact_contract_vendor_dislikes_character",
		response = "hub_interact_contract_vendor_dislikes_character",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_interaction",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
			{
				"user_memory",
				"last_contract_vendor_dislikes_character",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_contract_vendor_dislikes_character",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_interact_contract_vendor_likes_character",
		response = "hub_interact_contract_vendor_likes_character",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"contract_vendor_interaction",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"veteran_male_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
			{
				"user_memory",
				"last_contract_vendor_likes_character",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_contract_vendor_likes_character",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_interact_explicator_likes_character",
		response = "hub_interact_explicator_likes_character",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_interact_explicator_likes_character",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_interact_penance_greeting_a",
		response = "hub_interact_penance_greeting_a",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_interact_penance_greeting_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_interact_purser_dislikes_character",
		response = "hub_interact_purser_dislikes_character",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_interact_purser_dislikes_character",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"user_memory",
				"last_purser_dislikes_character",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_purser_dislikes_character",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_interact_purser_likes_character",
		response = "hub_interact_purser_likes_character",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_interact_purser_likes_character",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_interact_shipmistress_dislikes_character",
		response = "hub_interact_shipmistress_dislikes_character",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"shipmistress_dislikes_character",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"low_level",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
			{
				"user_memory",
				"last_shipmistress_dislikes_character",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_shipmistress_dislikes_character",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_interact_shipmistress_likes_character",
		response = "hub_interact_shipmistress_likes_character",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"shipmistress_likes_character",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"high_level",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
			{
				"user_memory",
				"last_shipmistress_likes_character",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_shipmistress_likes_character",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_interact_training_ground_psyker_dislikes_character",
		response = "hub_interact_training_ground_psyker_dislikes_character",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"training_ground_psyker_dislikes_character",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"veteran_female_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"user_memory",
				"last_training_ground_psyker_dislikes_character",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_training_ground_psyker_dislikes_character",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_interact_training_ground_psyker_likes_character",
		response = "hub_interact_training_ground_psyker_likes_character",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"training_ground_psyker_likes_character",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
			{
				"user_memory",
				"last_training_ground_psyker_likes_character",
				OP.TIMEDIFF,
				OP.GT,
				5,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_training_ground_psyker_likes_character",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "chorus_vo_prio_1",
		database = "conversations_hub",
		name = "hub_map_table_call_and_response_01_b",
		response = "hub_map_table_call_and_response_01_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_commissar_a__hub_map_table_call_and_response_01_a_01",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_call_and_response_01_c",
		response = "hub_map_table_call_and_response_01_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_a__hub_map_table_call_and_response_01_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "chorus_vo_prio_1",
		database = "conversations_hub",
		name = "hub_map_table_call_and_response_02_b",
		response = "hub_map_table_call_and_response_02_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_commissar_a__hub_map_table_call_and_response_02_a_01",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_01_b",
		response = "hub_map_table_conversation_01_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_commissar_a__hub_map_table_conversation_01_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_01_c",
		response = "hub_map_table_conversation_01_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_officer_male_a__hub_map_table_conversation_01_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_01_d",
		response = "hub_map_table_conversation_01_d",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_commissar_a__hub_map_table_conversation_01_c_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_02_b",
		response = "hub_map_table_conversation_02_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_commissar_a__hub_map_table_conversation_02_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_02_c",
		response = "hub_map_table_conversation_02_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_officer_male_a__hub_map_table_conversation_02_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_03_b",
		response = "hub_map_table_conversation_03_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_commissar_a__hub_map_table_conversation_03_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_03_c",
		response = "hub_map_table_conversation_03_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_officer_male_a__hub_map_table_conversation_03_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_03_d",
		response = "hub_map_table_conversation_03_d",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_commissar_a__hub_map_table_conversation_03_c_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_04_b",
		response = "hub_map_table_conversation_04_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_commissar_a__hub_map_table_conversation_04_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_04_c",
		response = "hub_map_table_conversation_04_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_officer_male_a__hub_map_table_conversation_04_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_05_b",
		response = "hub_map_table_conversation_05_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_commissar_a__hub_map_table_conversation_05_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_05_c",
		response = "hub_map_table_conversation_05_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_officer_male_a__hub_map_table_conversation_05_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_06_b",
		response = "hub_map_table_conversation_06_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_officer_male_a__hub_map_table_conversation_06_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_06_c",
		response = "hub_map_table_conversation_06_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_commissar_a__hub_map_table_conversation_06_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_06_d",
		response = "hub_map_table_conversation_06_d",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_officer_male_a__hub_map_table_conversation_06_c_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_07_b",
		response = "hub_map_table_conversation_07_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_a__hub_map_table_conversation_07_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_08_b",
		response = "hub_map_table_conversation_08_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_a__hub_map_table_conversation_08_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_08_c",
		response = "hub_map_table_conversation_08_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_b__hub_map_table_conversation_08_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_08_d",
		response = "hub_map_table_conversation_08_d",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_a__hub_map_table_conversation_08_c_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_08_e",
		response = "hub_map_table_conversation_08_e",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_b__hub_map_table_conversation_08_d_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_09_b",
		response = "hub_map_table_conversation_09_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_a__hub_map_table_conversation_09_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_09_c",
		response = "hub_map_table_conversation_09_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_b__hub_map_table_conversation_09_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_09_d",
		response = "hub_map_table_conversation_09_d",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_a__hub_map_table_conversation_09_c_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_10_b",
		response = "hub_map_table_conversation_10_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_a__hub_map_table_conversation_10_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_10_c",
		response = "hub_map_table_conversation_10_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_b__hub_map_table_conversation_10_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_10_d",
		response = "hub_map_table_conversation_10_d",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_a__hub_map_table_conversation_10_c_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_11_b",
		response = "hub_map_table_conversation_11_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_b__hub_map_table_conversation_11_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_11_c",
		response = "hub_map_table_conversation_11_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_a__hub_map_table_conversation_11_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_11_d",
		response = "hub_map_table_conversation_11_d",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_b__hub_map_table_conversation_11_c_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_12_b",
		response = "hub_map_table_conversation_12_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_b__hub_map_table_conversation_12_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_12_c",
		response = "hub_map_table_conversation_12_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_a__hub_map_table_conversation_12_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_12_d",
		response = "hub_map_table_conversation_12_d",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_steelhead_b__hub_map_table_conversation_12_c_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_commissar",
		response = "hub_map_table_conversation_commissar",
		wwise_route = 19,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_map_table_conversation_commissar",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"hub_map_table_exchange",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				12,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_map_table_exchange",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_officer",
		response = "hub_map_table_conversation_officer",
		wwise_route = 19,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_map_table_conversation_officer",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
			{
				"faction_memory",
				"hub_map_table_exchange",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				12,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_map_table_exchange",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_steelhead_a",
		response = "hub_map_table_conversation_steelhead_a",
		wwise_route = 19,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_map_table_conversation_steelhead_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
			{
				"faction_memory",
				"hub_map_table_exchange",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				12,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_map_table_exchange",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_map_table_conversation_steelhead_b",
		response = "hub_map_table_conversation_steelhead_b",
		wwise_route = 19,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_map_table_conversation_steelhead_b",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
			{
				"faction_memory",
				"hub_map_table_exchange",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				12,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_map_table_exchange",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mindwipe_backstory_a",
		response = "hub_mindwipe_backstory_a",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_mindwipe_backstory_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mindwipe_body_type_a",
		response = "hub_mindwipe_body_type_a",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_mindwipe_body_type_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mindwipe_conclusion_a",
		response = "hub_mindwipe_conclusion_a",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_mindwipe_conclusion_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mindwipe_frequent_customer_a",
		response = "hub_mindwipe_frequent_customer_a",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_mindwipe_frequent_customer_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mindwipe_personality_a",
		response = "hub_mindwipe_personality_a",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_mindwipe_personality_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mindwipe_select_option_a",
		response = "hub_mindwipe_select_option_a",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_mindwipe_select_option_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_carnival_a",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_carnival_a",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"cm_raid",
					"fm_armoury",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"false",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_carnival_circumstance_a",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_carnival_circumstance_a",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"cm_raid",
					"fm_armoury",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"true",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_core_a",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_core_a",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"core_research",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"false",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_core_circumstance_a",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_core_circumstance_a",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"core_research",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"true",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_dust",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_dust",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"dm_propaganda",
					"hm_strain",
					"lm_scavenge",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"false",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_dust_circumstance",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_dust_circumstance",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"dm_propaganda",
					"hm_strain",
					"lm_scavenge",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"true",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_tank_foundry",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_tank_foundry",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"dm_forge",
					"fm_cargo",
					"lm_cooling",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"false",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_tank_foundry_circumstance",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_tank_foundry_circumstance",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"dm_forge",
					"fm_cargo",
					"lm_cooling",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"true",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_throneside_a",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_throneside_a",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"cm_archives",
					"fm_resurgence",
					"hm_complex",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"false",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_throneside_circumstance_a",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_throneside_circumstance_a",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"cm_archives",
					"fm_resurgence",
					"hm_complex",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"true",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_transit",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_transit",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"cm_habs",
					"km_station",
					"lm_rails",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"false",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_transit_circumstance",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_transit_circumstance",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"cm_habs",
					"km_station",
					"lm_rails",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"true",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_watertown",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_watertown",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"km_enforcer",
					"dm_stockpile",
					"hm_cartel",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"false",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_mission_board_announcement_watertown_circumstance",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_mission_board_announcement_watertown_circumstance",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_update_vo",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"mission_update",
			},
			{
				"query_context",
				"mission",
				OP.SET_INCLUDES,
				args = {
					"km_enforcer",
					"dm_stockpile",
					"hm_cartel",
				},
			},
			{
				"query_context",
				"is_circumstance",
				OP.EQ,
				"true",
			},
			{
				"query_context",
				"class_name",
				OP.EQ,
				"mourningstar_servitor",
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMESET,
			},
			{
				"user_memory",
				"last_mission_update_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_news_announcement",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_news_announcement",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"random_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_servitor_c",
				},
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				139,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				329,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMESET,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_propaganda_announcement",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_propaganda_announcement",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"random_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"vocator_b",
				},
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				139,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				229,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMESET,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_rumour_barber_idle",
		response = "hub_rumour_barber_idle",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_rumour_barber_idle",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"barber",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_rumour_farewell_a_barber",
		response = "hub_rumour_farewell_a_barber",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_rumour_farewell_a_barber",
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
					"zealot_male_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"barber",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hub_rumours_vox_01_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_rumours_vox_01_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_01_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hub_rumours_vox_02_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_rumours_vox_02_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_02_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_02_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hub_rumours_vox_03_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_rumours_vox_03_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_03_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_03_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_04_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_04_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hub_rumours_vox_04_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_rumours_vox_04_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_04_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_04_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_04_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_05_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_05_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hub_rumours_vox_05_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_rumours_vox_05_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_05_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_05_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_05_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_06_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_06_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hub_rumours_vox_06_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_rumours_vox_06_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_06_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_06_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_06_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_07_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_07_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"hub_rumours_vox_07_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_rumours_vox_07_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_07_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_07_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_07_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_07_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_07_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_07_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_07_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_07_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_07_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_08_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_08_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_rumours_vox_08_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_rumours_vox_08_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_08_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_08_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_08_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_09_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_09_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
			{
				"faction_memory",
				"hub_rumours_vox_09_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_rumours_vox_09_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_09_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_09_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_09_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_10_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_10_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_giver_conversation_starter",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
			{
				"faction_memory",
				"hub_rumours_vox_10_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"hub_rumours_vox_10_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_10_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_10_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_10_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_10_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_10_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_10_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "hub_rumours_vox_10_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_rumours_vox_10_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"hub_rumours_vox_10_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"contract_vendor",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_seasonal_juno_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_seasonal_juno_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_seasonal_juno_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_seasonal_kalyx_mid_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_seasonal_kalyx_mid_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_seasonal_kalyx_mid_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "hub_seasonal_kalyx_start_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "hub_seasonal_kalyx_start_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"hub_seasonal_kalyx_start_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "hub_status_announcement",
		pre_wwise_event = "play_hub_pa_notification",
		response = "hub_status_announcement",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"random_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_servitor_b",
				},
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				139,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				329,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMESET,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "may_hub_announcement",
		pre_wwise_event = "play_hub_pa_notification",
		response = "may_hub_announcement",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"random_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"sergeant_a",
				},
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				139,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				229,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMESET,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "all_including_self",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_04_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_04_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"may_hub_conversation_04_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"may_hub_conversation_04_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_04_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_04_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"may_hub_conversation_04_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enginseer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_05_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_05_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enginseer",
				},
			},
			{
				"faction_memory",
				"may_hub_conversation_05_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"may_hub_conversation_05_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_05_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_05_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"may_hub_conversation_05_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_05_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_05_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"may_hub_conversation_05_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enginseer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_09_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_09_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enginseer",
				},
			},
			{
				"faction_memory",
				"may_hub_conversation_09_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"may_hub_conversation_09_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_09_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_09_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"may_hub_conversation_09_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_12_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_12_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"may_hub_conversation_12_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"may_hub_conversation_12_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_12_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_12_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"may_hub_conversation_12_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_13_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_13_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"may_hub_conversation_13_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"may_hub_conversation_13_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_13_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_13_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"may_hub_conversation_13_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_13_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_13_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"may_hub_conversation_13_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_14_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_14_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"may_hub_conversation_14_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"may_hub_conversation_14_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_14_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_14_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"may_hub_conversation_14_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_16_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_16_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"may_hub_conversation_16_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"may_hub_conversation_16_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_16_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_16_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"may_hub_conversation_16_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_17_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_17_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"may_hub_conversation_17_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"may_hub_conversation_17_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_17_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_17_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"may_hub_conversation_17_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_17_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_17_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"may_hub_conversation_17_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_18_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_18_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"may_hub_conversation_18_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"may_hub_conversation_18_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "may_hub_conversation_18_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "may_hub_conversation_18_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"may_hub_conversation_18_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "mourningstar_announcement_a",
		pre_wwise_event = "play_hub_pa_notification",
		response = "mourningstar_announcement_a",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"random_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_confessor_a",
					"mourningstar_wing_commander_a",
				},
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				139,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				229,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMESET,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_1",
		database = "conversations_hub",
		name = "npc_first_interaction_boon_vendor",
		response = "npc_first_interaction_boon_vendor",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"environmental_story",
			},
			{
				"user_context",
				"friends_close",
				OP.GT,
				1,
			},
			{
				"user_context",
				"enemies_close",
				OP.LT,
				4,
			},
			{
				"query_context",
				"story_name",
				OP.EQ,
				"",
			},
			{
				"faction_memory",
				"",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"",
				OP.ADD,
				1,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "npc_first_interaction_contract_vendor_a",
		response = "npc_first_interaction_contract_vendor_a",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "npc_first_interaction_contract_vendor_b",
		response = "npc_first_interaction_contract_vendor_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "npc_first_interaction_contract_vendor_c",
		response = "npc_first_interaction_contract_vendor_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "npc_first_interaction_contract_vendor_d",
		response = "npc_first_interaction_contract_vendor_d",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "npc_first_interaction_contract_vendor_e",
		response = "npc_first_interaction_contract_vendor_e",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "npc_first_interaction_purser_a",
		response = "npc_first_interaction_purser_a",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"npc_first_interaction_purser_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "npc_first_interaction_purser_b",
		response = "npc_first_interaction_purser_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"npc_first_interaction_purser_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "npc_first_interaction_purser_c",
		response = "npc_first_interaction_purser_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"npc_first_interaction_purser_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "npc_first_interaction_purser_d",
		response = "npc_first_interaction_purser_d",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"npc_first_interaction_purser_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "npc_first_interaction_purser_e",
		response = "npc_first_interaction_purser_e",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"npc_first_interaction_purser_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "npc_first_interaction_shipmistress",
		response = "npc_first_interaction_shipmistress",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_01_b",
		response = "oval_hub_conversation_01_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_tech_priest_a__oval_hub_conversation_01_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_02_b",
		response = "oval_hub_conversation_02_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_travelling_salesman_a__oval_hub_conversation_02_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_03_b",
		response = "oval_hub_conversation_03_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_travelling_salesman_a__oval_hub_conversation_03_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_04_b",
		response = "oval_hub_conversation_04_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_tech_priest_a__oval_hub_conversation_04_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_05_b",
		response = "oval_hub_conversation_05_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_tech_priest_a__oval_hub_conversation_05_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_21_b",
		response = "oval_hub_conversation_21_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_travelling_salesman_a__oval_hub_conversation_21_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_21_c",
		response = "oval_hub_conversation_21_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_f__oval_hub_conversation_21_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_22_b",
		response = "oval_hub_conversation_22_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_g__oval_hub_conversation_22_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_22_c",
		response = "oval_hub_conversation_22_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_travelling_salesman_a__oval_hub_conversation_23_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_24_b",
		response = "oval_hub_conversation_24_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_travelling_salesman_a__oval_hub_conversation_24_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_24_c",
		response = "oval_hub_conversation_24_c",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_f__oval_hub_conversation_24_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_24_d",
		response = "oval_hub_conversation_24_d",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_g__oval_hub_conversation_25_c_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "visible_npcs",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_hadron",
		response = "oval_hub_conversation_hadron",
		wwise_route = 19,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"oval_hub_conversation_hadron",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"faction_memory",
				"crafting_exchange",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				12,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"crafting_exchange",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "oval_hub_conversation_swagger",
		response = "oval_hub_conversation_swagger",
		wwise_route = 19,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"oval_hub_conversation_swagger",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"travelling_salesman",
				},
			},
			{
				"faction_memory",
				"crafting_exchange",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				12,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"crafting_exchange",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_01_b",
		response = "oval_hub_soldier_exchange_01_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_b__oval_hub_soldier_exchange_01_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_02_b",
		response = "oval_hub_soldier_exchange_02_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_e__oval_hub_soldier_exchange_02_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_03_b",
		response = "oval_hub_soldier_exchange_03_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_e__oval_hub_soldier_exchange_03_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_04_b",
		response = "oval_hub_soldier_exchange_04_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_b__oval_hub_soldier_exchange_04_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_05_b",
		response = "oval_hub_soldier_exchange_05_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_b__oval_hub_soldier_exchange_05_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_06_b",
		response = "oval_hub_soldier_exchange_06_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_f__oval_hub_soldier_exchange_06_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_07_b",
		response = "oval_hub_soldier_exchange_07_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_g__oval_hub_soldier_exchange_07_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_08_b",
		response = "oval_hub_soldier_exchange_08_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_f__oval_hub_soldier_exchange_08_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_09_b",
		response = "oval_hub_soldier_exchange_09_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_g__oval_hub_soldier_exchange_09_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_10_b",
		response = "oval_hub_soldier_exchange_10_b",
		wwise_route = 19,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_mourningstar_soldier_male_f__oval_hub_soldier_exchange_10_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_male_b",
		response = "oval_hub_soldier_exchange_male_b",
		wwise_route = 19,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"oval_hub_soldier_exchange_male_b",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
			{
				"faction_memory",
				"exchange_male_b_male_e",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				12,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"exchange_male_b_male_e",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_male_e",
		response = "oval_hub_soldier_exchange_male_e",
		wwise_route = 19,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"oval_hub_soldier_exchange_male_e",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
			{
				"faction_memory",
				"exchange_male_b_male_e",
				OP.TIMEDIFF,
				OP.GT,
				180,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				12,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"exchange_male_b_male_e",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_male_f",
		response = "oval_hub_soldier_exchange_male_f",
		wwise_route = 19,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"oval_hub_soldier_exchange_male_f",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
			{
				"faction_memory",
				"crafting_exchange",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				12,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"crafting_exchange",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "oval_hub_soldier_exchange_male_g",
		response = "oval_hub_soldier_exchange_male_g",
		wwise_route = 19,
		speaker_routing = {
			target = "all",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"oval_hub_soldier_exchange_male_g",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"mourningstar_soldier",
				},
			},
			{
				"faction_memory",
				"crafting_exchange",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				12,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				25,
			},
		},
		on_done = {
			{
				"faction_memory",
				"crafting_exchange",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "visible_npcs",
		},
	})
	define_rule({
		category = "npc_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "pilot_distance",
		response = "pilot_distance",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"pilot_distance",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "prologue_hub_go_mission_board_a",
		pre_wwise_event = "play_radio_static_start",
		response = "prologue_hub_go_mission_board_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"mission_info",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"prologue_hub_go_mission_board_a",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "prologue_hub_go_mission_board_b",
		response = "prologue_hub_go_mission_board_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"prologue_hub_go_mission_board_b",
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
					"zealot_male_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "prologue_hub_go_mission_board_c",
		post_wwise_event = "play_radio_static_end",
		response = "prologue_hub_go_mission_board_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"prologue_hub_go_mission_board_c",
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
					"zealot_male_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "purser_goodbye_dislikes_character",
		response = "purser_goodbye_dislikes_character",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"purser_goodbye",
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
					"zealot_female_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "purser_goodbye_likes_character",
		response = "purser_goodbye_likes_character",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"purser_goodbye",
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
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "purser_purchase",
		response = "purser_purchase",
		wwise_route = 40,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"purser_purchase",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
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
					"zealot_male_c",
				},
			},
			{
				"user_memory",
				"last_t",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
		},
		on_done = {
			{
				"user_memory",
				"last_",
				OP.TIMESET,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "reject_npc_goodbye_a",
		response = "reject_npc_goodbye_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "reject_npc_hub_interact_a",
		response = "reject_npc_hub_interact_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "reject_npc_purchase_a",
		response = "reject_npc_purchase_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_01_b",
		response = "shipmistress_hub_announcement_a_01_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_01_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_01_c",
		response = "shipmistress_hub_announcement_a_01_c",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_01_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_02_b",
		response = "shipmistress_hub_announcement_a_02_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_02_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_03_b",
		response = "shipmistress_hub_announcement_a_03_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_03_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_04_b",
		response = "shipmistress_hub_announcement_a_04_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_04_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_05_b",
		response = "shipmistress_hub_announcement_a_05_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_05_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_06_b",
		response = "shipmistress_hub_announcement_a_06_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_06_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_07_b",
		response = "shipmistress_hub_announcement_a_07_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_07_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_09_b",
		response = "shipmistress_hub_announcement_a_09_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_09_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_16_b",
		response = "shipmistress_hub_announcement_a_16_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_16_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_17_b",
		response = "shipmistress_hub_announcement_a_17_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_17_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_20_b",
		response = "shipmistress_hub_announcement_a_20_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_20_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_20_c",
		response = "shipmistress_hub_announcement_a_20_c",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_20_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_32_b",
		post_wwise_event = "play_radio_static_end",
		response = "shipmistress_hub_announcement_a_32_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_32_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_33_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_a_33_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_33_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_35_b",
		post_wwise_event = "play_radio_static_end",
		response = "shipmistress_hub_announcement_a_35_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_35_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_37_b",
		post_wwise_event = "play_radio_static_end",
		response = "shipmistress_hub_announcement_a_37_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_37_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_48_b",
		response = "shipmistress_hub_announcement_a_48_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_48_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_50_b",
		response = "shipmistress_hub_announcement_a_50_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_50_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_52_b",
		post_wwise_event = "play_radio_static_end",
		response = "shipmistress_hub_announcement_a_52_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_52_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_55_b",
		response = "shipmistress_hub_announcement_a_55_b",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_55_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"vocator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_55_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_a_55_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_55_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_56_b",
		response = "shipmistress_hub_announcement_a_56_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_56_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_56_c",
		post_wwise_event = "play_radio_static_end",
		response = "shipmistress_hub_announcement_a_56_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_56_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_60_b",
		post_wwise_event = "play_radio_static_end",
		response = "shipmistress_hub_announcement_a_60_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_60_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_a_61_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_a_61_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_61_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "all",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_b_25_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_b_25_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_25_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_b_26_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_b_26_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_26_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"explicator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_b_27_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_b_27_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_27_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_b_28_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_b_28_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_28_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"pilot",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_b_29_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_b_29_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_29_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_b_30_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_b_30_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_30_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_b_44_b",
		response = "shipmistress_hub_announcement_b_44_b",
		wwise_route = 42,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_44_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_b_45_b",
		response = "shipmistress_hub_announcement_b_45_b",
		wwise_route = 42,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_45_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_b_46_b",
		response = "shipmistress_hub_announcement_b_46_b",
		wwise_route = 42,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_46_a_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_b_50_b",
		response = "shipmistress_hub_announcement_b_50_b",
		wwise_route = 0,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_a_50_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"ogryn",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.3,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_c_28_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_c_28_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_pilot_a__shipmistress_hub_announcement_b_28_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_c_30_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_c_30_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_purser_a__shipmistress_hub_announcement_b_30_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_c_46_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_c_46_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_training_ground_psyker_a__shipmistress_hub_announcement_b_46_b_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_d_30_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_d_30_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_c_30_c_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"purser",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_d_46_d",
		response = "shipmistress_hub_announcement_d_46_d",
		wwise_route = 42,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"sound_event",
				OP.SET_INCLUDES,
				args = {
					"loc_shipmistress_a__shipmistress_hub_announcement_c_46_c_01",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"training_ground_psyker",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_pa",
		pre_wwise_event = "play_hub_pa_notification",
		response = "shipmistress_hub_announcement_pa",
		wwise_route = 22,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"generic_vo_event",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"random_talk",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"shipmistress_a",
				},
			},
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMEDIFF,
				OP.GT,
				139,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMEDIFF,
				OP.GT,
				229,
			},
			{
				"faction_memory",
				"last_mission_update",
				OP.TIMEDIFF,
				OP.GT,
				15,
			},
		},
		on_done = {
			{
				"faction_memory",
				"time_since_last_random_talk",
				OP.TIMESET,
			},
			{
				"user_memory",
				"time_since_last_random_talk_user",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "all_including_self",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "shipmistress_hub_announcement_vox",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "shipmistress_hub_announcement_vox",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"shipmistress",
				},
			},
			{
				"faction_memory",
				"shipmistress_hub_announcement_vox",
				OP.TIMEDIFF,
				OP.GT,
				240,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				100,
			},
		},
		on_done = {
			{
				"faction_memory",
				"shipmistress_hub_announcement_vox",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "all_including_self",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_01_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_01_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"southwark_hub_conversation_01_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"southwark_hub_conversation_01_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_01_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_01_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_01_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_01_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_02_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_02_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"southwark_hub_conversation_02_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"southwark_hub_conversation_02_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_02_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_02_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_02_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_02_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_02_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_02_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_02_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_03_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"southwark_hub_conversation_03_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"southwark_hub_conversation_03_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_03_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_03_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_03_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_03_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_04_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_04_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
			{
				"faction_memory",
				"southwark_hub_conversation_04_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"southwark_hub_conversation_04_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_04_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_04_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_04_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_04_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_04_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_04_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"interrogator",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_05_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_05_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"southwark_hub_conversation_05_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"southwark_hub_conversation_05_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_05_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_05_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_05_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_05_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_05_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_05_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_05_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_05_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_05_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_05_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_05_e",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_05_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_06_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_06_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"southwark_hub_conversation_06_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"southwark_hub_conversation_06_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_06_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_06_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_06_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enginseer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_06_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_06_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_06_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_06_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_06_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_06_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enginseer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "all",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_07_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_07_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
			{
				"faction_memory",
				"southwark_hub_conversation_07_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"southwark_hub_conversation_07_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_07_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_07_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_07_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enginseer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_07_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_07_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_07_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_07_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_07_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_07_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"enginseer",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "all",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_08_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_08_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"southwark_hub_conversation_08_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"southwark_hub_conversation_08_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_08_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_08_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_08_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_08_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_08_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_08_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_08_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_08_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_08_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_08_e",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_08_e",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_08_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_09_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_09_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"southwark_hub_conversation_09_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"southwark_hub_conversation_09_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_09_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_09_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_09_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_09_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_09_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_09_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_09_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_09_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_09_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_10_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_10_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"southwark_hub_conversation_10_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"southwark_hub_conversation_10_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_10_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_10_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_10_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_10_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_10_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_10_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_11_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_11_a",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"query_context",
				"trigger_id",
				OP.EQ,
				"npc_story_talk",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
			{
				"faction_memory",
				"southwark_hub_conversation_11_a",
				OP.TIMEDIFF,
				OP.GT,
				4800,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMEDIFF,
				OP.GT,
				120,
			},
		},
		on_done = {
			{
				"faction_memory",
				"southwark_hub_conversation_11_a",
				OP.TIMESET,
			},
			{
				"faction_memory",
				"time_since_last_vox_story_talk",
				OP.TIMESET,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_11_b",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_11_b",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_11_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_11_c",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_11_c",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_11_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"commissar",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "mission_givers",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "conversations_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "southwark_hub_conversation_11_d",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_conversation_11_d",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"heard_speak",
			},
			{
				"query_context",
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"southwark_hub_conversation_11_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"sergeant",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 0.2,
			},
		},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "southwark_hub_first_greeting_launch_a",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_first_greeting_launch_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"southwark_hub_first_greeting_launch_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "southwark_hub_first_greeting_launch_b",
		response = "southwark_hub_first_greeting_launch_b",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"southwark_hub_first_greeting_launch_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "southwark_hub_first_greeting_launch_c",
		response = "southwark_hub_first_greeting_launch_c",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"southwark_hub_first_greeting_launch_c",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "southwark_hub_first_greeting_launch_d",
		response = "southwark_hub_first_greeting_launch_d",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"southwark_hub_first_greeting_launch_d",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "southwark_hub_first_greeting_launch_e",
		post_wwise_event = "play_radio_static_end",
		response = "southwark_hub_first_greeting_launch_e",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"southwark_hub_first_greeting_launch_e",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "southwark_hub_first_greeting_launch_f",
		pre_wwise_event = "play_radio_static_start",
		response = "southwark_hub_first_greeting_launch_f",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"southwark_hub_first_greeting_launch_f",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "southwark_hub_first_greeting_launch_g",
		post_wwise_event = "play_radio_static_end",
		response = "southwark_hub_first_greeting_launch_g",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"southwark_hub_first_greeting_launch_g",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "tech_priest_distance",
		response = "tech_priest_distance",
		wwise_route = 19,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"tech_priest_distance",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"ogryn_a",
					"ogryn_b",
					"ogryn_c",
					"ogryn_d",
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
					"zealot_male_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"tech_priest",
				},
			},
			{
				"query_context",
				"player_level_string",
				OP.SET_NOT_INCLUDES,
				args = {
					"0",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		concurrent_wwise_event = "play_vox_static_loop",
		database = "conversations_hub",
		name = "tech_priest_goodbye",
		response = "tech_priest_goodbye",
		wwise_route = 1,
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"tech_priest_goodbye",
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_01_a",
		pre_wwise_event = "play_radio_static_start",
		response = "twins_epilogue_01_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_01_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_01_b",
		response = "twins_epilogue_01_b",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_01_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_01_c",
		response = "twins_epilogue_01_c",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_01_c",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_01_d",
		response = "twins_epilogue_01_d",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_01_d",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_01_e",
		response = "twins_epilogue_01_e",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_01_e",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_01_f",
		response = "twins_epilogue_01_f",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_01_f",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_01_g",
		response = "twins_epilogue_01_g",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_01_g",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_01_h",
		response = "twins_epilogue_01_h",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_01_h",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_01_i",
		post_wwise_event = "play_radio_static_end",
		response = "twins_epilogue_01_i",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_01_i",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_02_a",
		response = "twins_epilogue_02_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_02_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_02_b",
		response = "twins_epilogue_02_b",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_02_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_02_c",
		response = "twins_epilogue_02_c",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_02_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_02_d",
		response = "twins_epilogue_02_d",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_02_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_02_e",
		response = "twins_epilogue_02_e",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_02_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_02_f",
		response = "twins_epilogue_02_f",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_02_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_02_g",
		response = "twins_epilogue_02_g",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_02_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_02_h",
		response = "twins_epilogue_02_h",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_02_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_02_i",
		response = "twins_epilogue_02_i",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_02_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_02_j",
		response = "twins_epilogue_02_j",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_02_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_02_k",
		response = "twins_epilogue_02_k",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_02_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_epilogue_03_a",
		post_wwise_event = "play_radio_static_end",
		pre_wwise_event = "play_radio_static_start",
		response = "twins_epilogue_03_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_epilogue_03_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_prologue_01_a",
		pre_wwise_event = "play_radio_static_start",
		response = "twins_prologue_01_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_prologue_01_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_prologue_01_b",
		response = "twins_prologue_01_b",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_prologue_01_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_prologue_01_c",
		response = "twins_prologue_01_c",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_prologue_01_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "twins_prologue_01_d",
		post_wwise_event = "play_radio_static_end",
		response = "twins_prologue_01_d",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"twins_prologue_01_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "uxbridge_hub_heresy_greeting_a",
		pre_wwise_event = "play_radio_static_start",
		response = "uxbridge_hub_heresy_greeting_a",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"uxbridge_hub_heresy_greeting_a",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "uxbridge_hub_heresy_greeting_b",
		response = "uxbridge_hub_heresy_greeting_b",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"uxbridge_hub_heresy_greeting_b",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
	define_rule({
		category = "npc_prio_0",
		database = "conversations_hub",
		name = "uxbridge_hub_heresy_greeting_c",
		post_wwise_event = "play_radio_static_end",
		response = "uxbridge_hub_heresy_greeting_c",
		wwise_route = 40,
		speaker_routing = {
			target = "dialogist",
		},
		criterias = {
			{
				"query_context",
				"concept",
				OP.EQ,
				"npc_interacting_vo",
			},
			{
				"query_context",
				"vo_event",
				OP.EQ,
				"uxbridge_hub_heresy_greeting_c",
			},
			{
				"query_context",
				"interactor_voice_profile",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"",
				},
			},
		},
		on_done = {},
	})
end
