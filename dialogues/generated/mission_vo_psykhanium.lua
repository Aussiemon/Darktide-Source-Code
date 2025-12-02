-- chunkname: @dialogues/generated/mission_vo_psykhanium.lua

return function ()
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "cmd_deploy_skull_horde",
		response = "cmd_deploy_skull_horde",
		wwise_route = 42,
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
				"cmd_deploy_skull",
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
				"cmd_deploy_skull",
				OP.TIMEDIFF,
				OP.GT,
				60,
			},
		},
		on_done = {
			{
				"user_memory",
				"cmd_deploy_skull",
				OP.TIMESET,
				0,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "cmd_hacking_place_device_horde",
		response = "cmd_hacking_place_device_horde",
		wwise_route = 42,
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
				"cmd_hacking_place_device",
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
			target = "players",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "cmd_luggable_prompt_a",
		response = "cmd_luggable_prompt_a",
		wwise_route = 42,
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
				OP.SET_INCLUDES,
				args = {
					"cmd_luggable_prompt_a",
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
				"faction_memory",
				"scanning_active",
				OP.EQ,
				0,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "cmd_luggable_prompt_a_all_targets_scanned",
		response = "cmd_luggable_prompt_a_all_targets_scanned",
		wwise_route = 42,
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
				OP.SET_INCLUDES,
				args = {
					"all_targets_scanned",
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
				"faction_memory",
				"scanning_active",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"horde_island",
				OP.NEQ,
				3,
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "cmd_wandering_skull_horde",
		response = "cmd_wandering_skull_horde",
		wwise_route = 42,
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
				"cmd_wandering_skull",
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
				"faction_memory",
				"cmd_wandering_skull",
				OP.TIMEDIFF,
				OP.GT,
				30,
			},
			{
				"faction_memory",
				"mission_scan_final",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"cmd_wandering_skull",
				OP.TIMESET,
				0,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "event_corruptor_objective_start",
		response = "event_corruptor_objective_start",
		wwise_route = 42,
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
				"event_corruptor_objective_start",
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
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "event_demolition_first_corruptor_destroyed_b_horde",
		response = "event_demolition_first_corruptor_destroyed_b_horde",
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
				"dialogue_name",
				OP.SET_INCLUDES,
				args = {
					"event_demolition_first_corruptor_destroyed_a",
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
				duration = 0.3,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "event_demolition_last_corruptor_horde",
		response = "event_demolition_last_corruptor_horde",
		wwise_route = 42,
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
				"event_demolition_last_corruptor",
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
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "event_scan_all_targets_scanned_horde",
		response = "event_scan_all_targets_scanned_horde",
		wwise_route = 42,
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
				"all_targets_scanned_disabled",
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
				duration = 0.5,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "event_scan_more_data_horde",
		response = "event_scan_more_data_horde",
		wwise_route = 42,
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
				"event_scan_more_data",
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
				"faction_memory",
				"event_scan_more_data",
				OP.EQ,
				OP.GT,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"event_scan_more_data",
				OP.ADD,
				0,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "event_scan_skull_waiting_horde",
		response = "event_scan_skull_waiting_horde",
		wwise_route = 42,
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
				"event_scan_skull_waiting",
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
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_claim_prize_a",
		response = "horde_claim_prize_a",
		wwise_route = 42,
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
				"horde_claim_prize_a",
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
				"faction_memory",
				"horde_claim_prize_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"horde_claim_prize_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_defend_area_a",
		response = "horde_defend_area_a",
		wwise_route = 42,
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
				"horde_defend_area_a",
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
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_mission_complete_a",
		response = "horde_mission_complete_a",
		wwise_route = 42,
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
				"horde_mission_complete_a",
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
				"faction_memory",
				"horde_mission_complete_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"horde_mission_complete_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_mode_failed_a",
		response = "horde_mode_failed_a",
		wwise_route = 42,
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
				"horde_mode_failed_a",
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
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_new_wave_start_post_upgrade_a",
		response = "horde_new_wave_start_post_upgrade_a",
		wwise_route = 42,
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
				"horde_new_wave_start_post_upgrade_a",
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
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_objective_a",
		response = "horde_objective_a",
		wwise_route = 42,
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
				"horde_objective_a",
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
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_objective_reminder_a",
		response = "horde_objective_reminder_a",
		wwise_route = 42,
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
				"horde_objective_reminder_a",
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
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_resupply_a",
		response = "horde_resupply_a",
		wwise_route = 42,
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
				"horde_resupply_a",
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
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_safe_zone_a",
		response = "horde_safe_zone_a",
		wwise_route = 42,
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
				"horde_safe_zone_a",
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
				"faction_memory",
				"horde_safe_zone_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"horde_safe_zone_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_safe_zone_b",
		response = "horde_safe_zone_b",
		wwise_route = 42,
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
				"horde_safe_zone_b",
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
				"faction_memory",
				"horde_safe_zone_b",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"horde_safe_zone_b",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_wave_interstitial_strain_a",
		response = "horde_wave_interstitial_strain_a",
		wwise_route = 42,
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
				"horde_wave_interstitial_strain_a",
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
				"faction_memory",
				"horde_wave_interstitial_strain_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"horde_wave_interstitial_strain_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "level_event",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_wave_interstitial_voices_a",
		response = "horde_wave_interstitial_voices_a",
		wwise_route = 42,
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
				"horde_wave_interstitial_voices_a",
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
				"faction_memory",
				"horde_wave_interstitial_voices_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"horde_wave_interstitial_voices_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_wave_start_01_a",
		response = "horde_wave_start_01_a",
		wwise_route = 42,
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
				"horde_wave_start_01_a",
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
				"faction_memory",
				"horde_wave_start_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"horde_wave_start_01_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_wave_start_02_a",
		response = "horde_wave_start_02_a",
		wwise_route = 42,
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
				"horde_wave_start_02_a",
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
				"faction_memory",
				"horde_wave_start_02_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"horde_wave_start_02_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_wave_start_03_a",
		response = "horde_wave_start_03_a",
		wwise_route = 42,
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
				"horde_wave_start_03_a",
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
				"faction_memory",
				"horde_wave_start_03_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"horde_wave_start_03_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "horde_wave_upgrade_prompt_a",
		response = "horde_wave_upgrade_prompt_a",
		wwise_route = 42,
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
				"horde_wave_upgrade_prompt_a",
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
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "info_servo_skull_deployed_horde",
		response = "info_servo_skull_deployed_horde",
		wwise_route = 42,
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
				"info_servo_skull_deployed",
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
				"info_servo_skull_deployed",
				OP.GTEQ,
				0,
			},
		},
		on_done = {
			{
				"user_memory",
				"info_servo_skull_deployed",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "players",
		},
		on_pre_rule_execution = {
			delay_vo = {
				duration = 1,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_00_a",
		response = "story_echo_brahms_00_a",
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
				"story_echo_brahms_00_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_matriarch_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_00_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_00_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_00_b",
		response = "story_echo_brahms_00_b",
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
					"story_echo_brahms_00_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_00_c",
		response = "story_echo_brahms_00_c",
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
					"story_echo_brahms_00_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_00_d",
		response = "story_echo_brahms_00_d",
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
					"story_echo_brahms_00_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_00_e",
		response = "story_echo_brahms_00_e",
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
					"story_echo_brahms_00_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_01_a",
		response = "story_echo_brahms_01_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_matriarch_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_01_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_00_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_01_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_01_b",
		response = "story_echo_brahms_01_b",
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
					"story_echo_brahms_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_01_c",
		response = "story_echo_brahms_01_c",
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
					"story_echo_brahms_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_01_d",
		response = "story_echo_brahms_01_d",
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
					"story_echo_brahms_01_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_01_e",
		response = "story_echo_brahms_01_e",
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
					"story_echo_brahms_01_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_01_f",
		response = "story_echo_brahms_01_f",
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
					"story_echo_brahms_01_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_02_a",
		response = "story_echo_brahms_02_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_mourningstar_officer_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_02_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_01_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_02_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_02_b",
		response = "story_echo_brahms_02_b",
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
					"story_echo_brahms_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_02_c",
		response = "story_echo_brahms_02_c",
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
					"story_echo_brahms_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_02_d",
		response = "story_echo_brahms_02_d",
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
					"story_echo_brahms_02_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_02_e",
		response = "story_echo_brahms_02_e",
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
					"story_echo_brahms_02_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_03_a",
		response = "story_echo_brahms_03_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_matriarch_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_03_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_02_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_03_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_03_b",
		response = "story_echo_brahms_03_b",
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
					"story_echo_brahms_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_03_c",
		response = "story_echo_brahms_03_c",
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
					"story_echo_brahms_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_03_d",
		response = "story_echo_brahms_03_d",
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
					"story_echo_brahms_03_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_03_e",
		response = "story_echo_brahms_03_e",
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
					"story_echo_brahms_03_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_04_a",
		response = "story_echo_brahms_04_a",
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
				"story_echo_brahms_04_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_04_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_04_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_04_b",
		response = "story_echo_brahms_04_b",
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
					"story_echo_brahms_04_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_04_c",
		response = "story_echo_brahms_04_c",
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
					"story_echo_brahms_04_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_04_d",
		response = "story_echo_brahms_04_d",
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
					"story_echo_brahms_04_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_04_e",
		response = "story_echo_brahms_04_e",
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
					"story_echo_brahms_04_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_04_f",
		response = "story_echo_brahms_04_f",
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
					"story_echo_brahms_04_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_04a_a",
		response = "story_echo_brahms_04a_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_04a_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_04_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_04a_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_04a_b",
		response = "story_echo_brahms_04a_b",
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
					"story_echo_brahms_04a_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_04a_c",
		response = "story_echo_brahms_04a_c",
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
					"story_echo_brahms_04a_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_04a_d",
		response = "story_echo_brahms_04a_d",
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
					"story_echo_brahms_04a_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_04a_e",
		response = "story_echo_brahms_04a_e",
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
					"story_echo_brahms_04a_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_04a_f",
		response = "story_echo_brahms_04a_f",
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
					"story_echo_brahms_04a_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_05_a",
		response = "story_echo_brahms_05_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_05_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_04a_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_05_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_05_b",
		response = "story_echo_brahms_05_b",
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
					"story_echo_brahms_05_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_05_c",
		response = "story_echo_brahms_05_c",
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
					"story_echo_brahms_05_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_05_d",
		response = "story_echo_brahms_05_d",
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
					"story_echo_brahms_05_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_05_e",
		response = "story_echo_brahms_05_e",
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
					"story_echo_brahms_05_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_05_f",
		response = "story_echo_brahms_05_f",
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
					"story_echo_brahms_05_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_06_a",
		response = "story_echo_brahms_06_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_matriarch_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_06_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_05_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_06_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_06_b",
		response = "story_echo_brahms_06_b",
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
					"story_echo_brahms_06_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_06_c",
		response = "story_echo_brahms_06_c",
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
					"story_echo_brahms_06_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_06_d",
		response = "story_echo_brahms_06_d",
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
					"story_echo_brahms_06_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_06_e",
		response = "story_echo_brahms_06_e",
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
					"story_echo_brahms_06_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_07_a",
		response = "story_echo_brahms_07_a",
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
				"story_echo_brahms_07_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_magos_biologis_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_07_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_07_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_07_b",
		response = "story_echo_brahms_07_b",
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
					"story_echo_brahms_07_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_07_c",
		response = "story_echo_brahms_07_c",
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
					"story_echo_brahms_07_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_07_d",
		response = "story_echo_brahms_07_d",
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
					"story_echo_brahms_07_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_07_e",
		response = "story_echo_brahms_07_e",
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
					"story_echo_brahms_07_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_07_f",
		response = "story_echo_brahms_07_f",
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
					"story_echo_brahms_07_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_08_a",
		response = "story_echo_brahms_08_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_matriarch_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_08_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_07_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_08_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_08_b",
		response = "story_echo_brahms_08_b",
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
					"story_echo_brahms_08_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_08_c",
		response = "story_echo_brahms_08_c",
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
					"story_echo_brahms_08_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_08_d",
		response = "story_echo_brahms_08_d",
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
					"story_echo_brahms_08_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_08_e",
		response = "story_echo_brahms_08_e",
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
					"story_echo_brahms_08_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_09_a",
		response = "story_echo_brahms_09_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_matriarch_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_09_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_08_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_09_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_09_b",
		response = "story_echo_brahms_09_b",
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
					"story_echo_brahms_09_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_09_c",
		response = "story_echo_brahms_09_c",
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
					"story_echo_brahms_09_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_09_d",
		response = "story_echo_brahms_09_d",
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
					"story_echo_brahms_09_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_09_e",
		response = "story_echo_brahms_09_e",
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
					"story_echo_brahms_09_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_10_a",
		response = "story_echo_brahms_10_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_alpha_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_10_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_09_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_10_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_10_b",
		response = "story_echo_brahms_10_b",
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
					"story_echo_brahms_10_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_10_c",
		response = "story_echo_brahms_10_c",
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
					"story_echo_brahms_10_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_10_d",
		response = "story_echo_brahms_10_d",
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
					"story_echo_brahms_10_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_10_e",
		response = "story_echo_brahms_10_e",
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
					"story_echo_brahms_10_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11_a",
		response = "story_echo_brahms_11_a",
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
				"story_echo_brahms_11_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_mourningstar_officer_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_11_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_11_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11_b",
		response = "story_echo_brahms_11_b",
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
					"story_echo_brahms_11_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11_c",
		response = "story_echo_brahms_11_c",
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
					"story_echo_brahms_11_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11_d",
		response = "story_echo_brahms_11_d",
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
					"story_echo_brahms_11_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11_e",
		response = "story_echo_brahms_11_e",
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
					"story_echo_brahms_11_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11a_a",
		response = "story_echo_brahms_11a_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_magos_biologis_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_11a_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_11_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_11a_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11a_b",
		response = "story_echo_brahms_11a_b",
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
					"story_echo_brahms_11a_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11a_c",
		response = "story_echo_brahms_11a_c",
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
					"story_echo_brahms_11a_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11a_d",
		response = "story_echo_brahms_11a_d",
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
					"story_echo_brahms_11a_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11b_a",
		response = "story_echo_brahms_11b_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_magos_biologis_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_11b_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_11a_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_11b_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11b_b",
		response = "story_echo_brahms_11b_b",
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
					"story_echo_brahms_11b_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11b_c",
		response = "story_echo_brahms_11b_c",
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
					"story_echo_brahms_11b_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11b_d",
		response = "story_echo_brahms_11b_d",
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
					"story_echo_brahms_11b_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11c_a",
		response = "story_echo_brahms_11c_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_alpha_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_11c_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_11b_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_11c_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11c_b",
		response = "story_echo_brahms_11c_b",
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
					"story_echo_brahms_11c_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11c_c",
		response = "story_echo_brahms_11c_c",
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
					"story_echo_brahms_11c_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11c_d",
		response = "story_echo_brahms_11c_d",
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
					"story_echo_brahms_11c_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_11c_e",
		response = "story_echo_brahms_11c_e",
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
					"story_echo_brahms_11c_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_12_a",
		response = "story_echo_brahms_12_a",
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
				"story_echo_brahms_12_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_mourningstar_officer_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_12_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_12_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_12_b",
		response = "story_echo_brahms_12_b",
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
					"story_echo_brahms_12_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_12_c",
		response = "story_echo_brahms_12_c",
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
					"story_echo_brahms_12_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_12_d",
		response = "story_echo_brahms_12_d",
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
					"story_echo_brahms_12_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_12_e",
		response = "story_echo_brahms_12_e",
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
					"story_echo_brahms_12_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_13_a",
		response = "story_echo_brahms_13_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_13_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_12_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_13_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_13_b",
		response = "story_echo_brahms_13_b",
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
					"story_echo_brahms_13_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_13_c",
		response = "story_echo_brahms_13_c",
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
					"story_echo_brahms_13_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_13_d",
		response = "story_echo_brahms_13_d",
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
					"story_echo_brahms_13_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_13_e",
		response = "story_echo_brahms_13_e",
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
					"story_echo_brahms_13_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_14_a",
		response = "story_echo_brahms_14_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_alpha_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_14_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_13_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_14_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_14_b",
		response = "story_echo_brahms_14_b",
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
					"story_echo_brahms_14_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_14_c",
		response = "story_echo_brahms_14_c",
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
					"story_echo_brahms_14_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_14_d",
		response = "story_echo_brahms_14_d",
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
					"story_echo_brahms_14_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_14_e",
		response = "story_echo_brahms_14_e",
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
					"story_echo_brahms_14_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_15_a",
		response = "story_echo_brahms_15_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_mourningstar_officer_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_15_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_14_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_15_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_15_b",
		response = "story_echo_brahms_15_b",
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
					"story_echo_brahms_15_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_15_c",
		response = "story_echo_brahms_15_c",
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
					"story_echo_brahms_15_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_15_d",
		response = "story_echo_brahms_15_d",
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
					"story_echo_brahms_15_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_15_e",
		response = "story_echo_brahms_15_e",
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
					"story_echo_brahms_15_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_15_f",
		response = "story_echo_brahms_15_f",
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
					"story_echo_brahms_15_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_16_a",
		response = "story_echo_brahms_16_a",
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
				"story_echo_brahms_16_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_16_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_16_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_16_b",
		response = "story_echo_brahms_16_b",
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
					"story_echo_brahms_16_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_16_c",
		response = "story_echo_brahms_16_c",
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
					"story_echo_brahms_16_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_16_d",
		response = "story_echo_brahms_16_d",
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
					"story_echo_brahms_16_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_16_e",
		response = "story_echo_brahms_16_e",
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
					"story_echo_brahms_16_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_16_f",
		response = "story_echo_brahms_16_f",
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
					"story_echo_brahms_16_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_17_a",
		response = "story_echo_brahms_17_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_17_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_16_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_17_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_17_b",
		response = "story_echo_brahms_17_b",
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
					"story_echo_brahms_17_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_17_c",
		response = "story_echo_brahms_17_c",
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
					"story_echo_brahms_17_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_17_d",
		response = "story_echo_brahms_17_d",
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
					"story_echo_brahms_17_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_17_e",
		response = "story_echo_brahms_17_e",
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
					"story_echo_brahms_17_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_17_f",
		response = "story_echo_brahms_17_f",
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
					"story_echo_brahms_17_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_17_g",
		response = "story_echo_brahms_17_g",
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
					"story_echo_brahms_17_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_18_a",
		response = "story_echo_brahms_18_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_18_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_17_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_18_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_18_b",
		response = "story_echo_brahms_18_b",
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
					"story_echo_brahms_18_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_18_c",
		response = "story_echo_brahms_18_c",
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
					"story_echo_brahms_18_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_18_d",
		response = "story_echo_brahms_18_d",
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
					"story_echo_brahms_18_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_18_e",
		response = "story_echo_brahms_18_e",
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
					"story_echo_brahms_18_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_19_a",
		response = "story_echo_brahms_19_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_19_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_18_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_19_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_19_b",
		response = "story_echo_brahms_19_b",
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
					"story_echo_brahms_19_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_19_c",
		response = "story_echo_brahms_19_c",
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
					"story_echo_brahms_19_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_19_d",
		response = "story_echo_brahms_19_d",
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
					"story_echo_brahms_19_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_19_e",
		response = "story_echo_brahms_19_e",
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
					"story_echo_brahms_19_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_19_f",
		response = "story_echo_brahms_19_f",
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
					"story_echo_brahms_19_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_20_a",
		response = "story_echo_brahms_20_a",
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
				"story_echo_brahms_20_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_20_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_20_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_20_b",
		response = "story_echo_brahms_20_b",
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
					"story_echo_brahms_20_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_20_c",
		response = "story_echo_brahms_20_c",
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
					"story_echo_brahms_20_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_20_d",
		response = "story_echo_brahms_20_d",
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
					"story_echo_brahms_20_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_20_e",
		response = "story_echo_brahms_20_e",
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
					"story_echo_brahms_20_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_20_f",
		response = "story_echo_brahms_20_f",
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
					"story_echo_brahms_20_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_20_g",
		response = "story_echo_brahms_20_g",
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
					"story_echo_brahms_20_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_21_a",
		response = "story_echo_brahms_21_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_21_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_20_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_21_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_21_b",
		response = "story_echo_brahms_21_b",
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
					"story_echo_brahms_21_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_21_c",
		response = "story_echo_brahms_21_c",
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
					"story_echo_brahms_21_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_21_d",
		response = "story_echo_brahms_21_d",
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
					"story_echo_brahms_21_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_21_e",
		response = "story_echo_brahms_21_e",
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
					"story_echo_brahms_21_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_21_f",
		response = "story_echo_brahms_21_f",
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
					"story_echo_brahms_21_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_22_a",
		response = "story_echo_brahms_22_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_22_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_21_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_22_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_22_b",
		response = "story_echo_brahms_22_b",
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
					"story_echo_brahms_22_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_22_c",
		response = "story_echo_brahms_22_c",
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
					"story_echo_brahms_22_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_22_d",
		response = "story_echo_brahms_22_d",
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
					"story_echo_brahms_22_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_23_a",
		response = "story_echo_brahms_23_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_armourer_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_23_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_22_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_23_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_23_b",
		response = "story_echo_brahms_23_b",
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
					"story_echo_brahms_23_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_23_c",
		response = "story_echo_brahms_23_c",
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
					"story_echo_brahms_23_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_23_d",
		response = "story_echo_brahms_23_d",
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
					"story_echo_brahms_23_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_23_e",
		response = "story_echo_brahms_23_e",
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
					"story_echo_brahms_23_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_23_f",
		response = "story_echo_brahms_23_f",
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
					"story_echo_brahms_23_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_23_g",
		response = "story_echo_brahms_23_g",
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
					"story_echo_brahms_23_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_23a_a",
		response = "story_echo_brahms_23a_a",
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
				"story_echo_brahms_23a_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_23a_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_23a_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_23a_b",
		response = "story_echo_brahms_23a_b",
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
					"story_echo_brahms_23a_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_23a_c",
		response = "story_echo_brahms_23a_c",
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
					"story_echo_brahms_23a_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_23a_d",
		response = "story_echo_brahms_23a_d",
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
					"story_echo_brahms_23a_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_23a_e",
		response = "story_echo_brahms_23a_e",
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
					"story_echo_brahms_23a_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_24_a",
		response = "story_echo_brahms_24_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_24_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_23a_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_24_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_24_b",
		response = "story_echo_brahms_24_b",
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
					"story_echo_brahms_24_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_24_c",
		response = "story_echo_brahms_24_c",
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
					"story_echo_brahms_24_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_24_d",
		response = "story_echo_brahms_24_d",
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
					"story_echo_brahms_24_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_24_e",
		response = "story_echo_brahms_24_e",
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
					"story_echo_brahms_24_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_25_a",
		response = "story_echo_brahms_25_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_25_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_36_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_25_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_25_b",
		response = "story_echo_brahms_25_b",
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
					"story_echo_brahms_25_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_25_c",
		response = "story_echo_brahms_25_c",
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
					"story_echo_brahms_25_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_25_d",
		response = "story_echo_brahms_25_d",
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
					"story_echo_brahms_25_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_25_e",
		response = "story_echo_brahms_25_e",
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
					"story_echo_brahms_25_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_26_a",
		response = "story_echo_brahms_26_a",
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
				"story_echo_brahms_26_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_26_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_26_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_26_b",
		response = "story_echo_brahms_26_b",
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
					"story_echo_brahms_26_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_26_c",
		response = "story_echo_brahms_26_c",
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
					"story_echo_brahms_26_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_26_d",
		response = "story_echo_brahms_26_d",
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
					"story_echo_brahms_26_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_26_e",
		response = "story_echo_brahms_26_e",
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
					"story_echo_brahms_26_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_26_f",
		response = "story_echo_brahms_26_f",
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
					"story_echo_brahms_26_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_26_g",
		response = "story_echo_brahms_26_g",
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
					"story_echo_brahms_26_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_26_h",
		response = "story_echo_brahms_26_h",
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
					"story_echo_brahms_26_g",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27_a",
		response = "story_echo_brahms_27_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_27_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_26_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_27_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27_b",
		response = "story_echo_brahms_27_b",
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
					"story_echo_brahms_27_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27_c",
		response = "story_echo_brahms_27_c",
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
					"story_echo_brahms_27_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27_d",
		response = "story_echo_brahms_27_d",
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
					"story_echo_brahms_27_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27_e",
		response = "story_echo_brahms_27_e",
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
					"story_echo_brahms_27_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27_f",
		response = "story_echo_brahms_27_f",
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
					"story_echo_brahms_27_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27a_a",
		response = "story_echo_brahms_27a_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_27a_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_27_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_27a_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27a_b",
		response = "story_echo_brahms_27a_b",
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
					"story_echo_brahms_27a_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27a_c",
		response = "story_echo_brahms_27a_c",
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
					"story_echo_brahms_27a_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27a_d",
		response = "story_echo_brahms_27a_d",
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
					"story_echo_brahms_27a_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27a_e",
		response = "story_echo_brahms_27a_e",
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
					"story_echo_brahms_27a_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27b_a",
		response = "story_echo_brahms_27b_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_27b_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_27a_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_27b_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27b_b",
		response = "story_echo_brahms_27b_b",
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
					"story_echo_brahms_27b_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27b_c",
		response = "story_echo_brahms_27b_c",
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
					"story_echo_brahms_27b_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27b_d",
		response = "story_echo_brahms_27b_d",
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
					"story_echo_brahms_27b_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27b_e",
		response = "story_echo_brahms_27b_e",
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
					"story_echo_brahms_27b_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_27b_f",
		response = "story_echo_brahms_27b_f",
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
					"story_echo_brahms_27b_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_28_a",
		response = "story_echo_brahms_28_a",
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
				"story_echo_brahms_28_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_28_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_28_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_28_b",
		response = "story_echo_brahms_28_b",
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
					"story_echo_brahms_28_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_28_c",
		response = "story_echo_brahms_28_c",
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
					"story_echo_brahms_28_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_28_d",
		response = "story_echo_brahms_28_d",
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
					"story_echo_brahms_28_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_29_a",
		response = "story_echo_brahms_29_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_enginseer_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_29_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_28_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_29_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_29_b",
		response = "story_echo_brahms_29_b",
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
					"story_echo_brahms_29_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_29_c",
		response = "story_echo_brahms_29_c",
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
					"story_echo_brahms_29_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_29_d",
		response = "story_echo_brahms_29_d",
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
					"story_echo_brahms_29_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_30_a",
		response = "story_echo_brahms_30_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_30_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_29_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_30_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_30_b",
		response = "story_echo_brahms_30_b",
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
					"story_echo_brahms_30_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_30_c",
		response = "story_echo_brahms_30_c",
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
					"story_echo_brahms_30_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_30_d",
		response = "story_echo_brahms_30_d",
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
					"story_echo_brahms_30_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_30_e",
		response = "story_echo_brahms_30_e",
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
					"story_echo_brahms_30_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_30_f",
		response = "story_echo_brahms_30_f",
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
					"story_echo_brahms_30_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_30a_a",
		response = "story_echo_brahms_30a_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_alpha_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_30a_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_30_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_30a_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_30a_b",
		response = "story_echo_brahms_30a_b",
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
					"story_echo_brahms_30a_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_30a_c",
		response = "story_echo_brahms_30a_c",
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
					"story_echo_brahms_30a_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_30a_d",
		response = "story_echo_brahms_30a_d",
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
					"story_echo_brahms_30a_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_30a_e",
		response = "story_echo_brahms_30a_e",
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
					"story_echo_brahms_30a_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_30a_f",
		response = "story_echo_brahms_30a_f",
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
					"story_echo_brahms_30a_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_36_a",
		response = "story_echo_brahms_36_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_shipmistress_a",
				},
			},
			{
				"faction_memory",
				"story_echo_brahms_36_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_brahms_24_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_brahms_36_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_36_b",
		response = "story_echo_brahms_36_b",
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
					"story_echo_brahms_36_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_36_c",
		response = "story_echo_brahms_36_c",
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
					"story_echo_brahms_36_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_36_d",
		response = "story_echo_brahms_36_d",
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
					"story_echo_brahms_36_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_brahms_36_e",
		response = "story_echo_brahms_36_e",
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
					"story_echo_brahms_36_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_01_a",
		response = "story_echo_marshal_01_a",
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
				"story_echo_marshal_01_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_marshal_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_marshal_01_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_01_b",
		response = "story_echo_marshal_01_b",
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
					"story_echo_marshal_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_01_c",
		response = "story_echo_marshal_01_c",
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
					"story_echo_marshal_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_01_d",
		response = "story_echo_marshal_01_d",
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
					"story_echo_marshal_01_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_01_e",
		response = "story_echo_marshal_01_e",
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
					"story_echo_marshal_01_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_02_a",
		response = "story_echo_marshal_02_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_adamant_officer_a",
				},
			},
			{
				"faction_memory",
				"story_echo_marshal_02_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_marshal_01_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_marshal_02_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_02_b",
		response = "story_echo_marshal_02_b",
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
					"story_echo_marshal_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_02_c",
		response = "story_echo_marshal_02_c",
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
					"story_echo_marshal_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_02_d",
		response = "story_echo_marshal_02_d",
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
					"story_echo_marshal_02_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_02_e",
		response = "story_echo_marshal_02_e",
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
					"story_echo_marshal_02_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_02_f",
		response = "story_echo_marshal_02_f",
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
					"story_echo_marshal_02_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_03_a",
		response = "story_echo_marshal_03_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_marshal_03_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_marshal_02_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_marshal_03_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_03_b",
		response = "story_echo_marshal_03_b",
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
					"story_echo_marshal_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_03_c",
		response = "story_echo_marshal_03_c",
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
					"story_echo_marshal_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_03_d",
		response = "story_echo_marshal_03_d",
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
					"story_echo_marshal_03_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_03_e",
		response = "story_echo_marshal_03_e",
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
					"story_echo_marshal_03_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_03_f",
		response = "story_echo_marshal_03_f",
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
					"story_echo_marshal_03_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_03_g",
		response = "story_echo_marshal_03_g",
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
					"story_echo_marshal_03_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_04_a",
		response = "story_echo_marshal_04_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_marshal_04_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_marshal_03_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_marshal_04_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_04_b",
		response = "story_echo_marshal_04_b",
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
					"story_echo_marshal_04_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_04_c",
		response = "story_echo_marshal_04_c",
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
					"story_echo_marshal_04_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_04_d",
		response = "story_echo_marshal_04_d",
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
					"story_echo_marshal_04_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_04_e",
		response = "story_echo_marshal_04_e",
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
					"story_echo_marshal_04_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_04_f",
		response = "story_echo_marshal_04_f",
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
					"story_echo_marshal_04_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_04_g",
		response = "story_echo_marshal_04_g",
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
					"story_echo_marshal_04_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_05_a",
		response = "story_echo_marshal_05_a",
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
				"story_echo_marshal_05_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_tech_priest_a",
				},
			},
			{
				"faction_memory",
				"story_echo_marshal_05_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_marshal_05_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_05_b",
		response = "story_echo_marshal_05_b",
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
					"story_echo_marshal_05_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_05_c",
		response = "story_echo_marshal_05_c",
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
					"story_echo_marshal_05_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_05_d",
		response = "story_echo_marshal_05_d",
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
					"story_echo_marshal_05_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_06_a",
		response = "story_echo_marshal_06_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_tech_priest_a",
				},
			},
			{
				"faction_memory",
				"story_echo_marshal_06_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_marshal_05_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_marshal_06_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_06_b",
		response = "story_echo_marshal_06_b",
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
					"story_echo_marshal_06_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_06_c",
		response = "story_echo_marshal_06_c",
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
					"story_echo_marshal_06_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_06_d",
		response = "story_echo_marshal_06_d",
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
					"story_echo_marshal_06_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_07_a",
		response = "story_echo_marshal_07_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_marshal_07_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_marshal_06_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_marshal_07_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_07_b",
		response = "story_echo_marshal_07_b",
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
					"story_echo_marshal_07_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_07_c",
		response = "story_echo_marshal_07_c",
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
					"story_echo_marshal_07_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_07_d",
		response = "story_echo_marshal_07_d",
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
					"story_echo_marshal_07_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_07_e",
		response = "story_echo_marshal_07_e",
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
					"story_echo_marshal_07_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_07_f",
		response = "story_echo_marshal_07_f",
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
					"story_echo_marshal_07_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_08_a",
		response = "story_echo_marshal_08_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_marshal_08_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_marshal_07_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_marshal_08_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_08_b",
		response = "story_echo_marshal_08_b",
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
					"story_echo_marshal_08_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_08_c",
		response = "story_echo_marshal_08_c",
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
					"story_echo_marshal_08_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_08_d",
		response = "story_echo_marshal_08_d",
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
					"story_echo_marshal_08_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_08_e",
		response = "story_echo_marshal_08_e",
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
					"story_echo_marshal_08_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_marshal_08_f",
		response = "story_echo_marshal_08_f",
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
					"story_echo_marshal_08_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_01_a",
		response = "story_echo_morrow_01_a",
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
				"story_echo_morrow_01_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_legion_captain_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_01_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_01_b",
		response = "story_echo_morrow_01_b",
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
					"story_echo_morrow_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_01_c",
		response = "story_echo_morrow_01_c",
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
					"story_echo_morrow_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_01_d",
		response = "story_echo_morrow_01_d",
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
					"story_echo_morrow_01_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_01_e",
		response = "story_echo_morrow_01_e",
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
					"story_echo_morrow_01_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_02_a",
		response = "story_echo_morrow_02_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_legion_captain_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_02_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_01_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_02_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_02_b",
		response = "story_echo_morrow_02_b",
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
					"story_echo_morrow_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_02_c",
		response = "story_echo_morrow_02_c",
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
					"story_echo_morrow_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_02_d",
		response = "story_echo_morrow_02_d",
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
					"story_echo_morrow_02_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_02_e",
		response = "story_echo_morrow_02_e",
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
					"story_echo_morrow_02_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_03_a",
		response = "story_echo_morrow_03_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_world_eater_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_03_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_02_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_03_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_03_b",
		response = "story_echo_morrow_03_b",
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
					"story_echo_morrow_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_03_c",
		response = "story_echo_morrow_03_c",
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
					"story_echo_morrow_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_03_d",
		response = "story_echo_morrow_03_d",
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
					"story_echo_morrow_03_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_03_e",
		response = "story_echo_morrow_03_e",
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
					"story_echo_morrow_03_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_03_f",
		response = "story_echo_morrow_03_f",
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
					"story_echo_morrow_03_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_04_a",
		response = "story_echo_morrow_04_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_b",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_04_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_03_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_04_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_04_b",
		response = "story_echo_morrow_04_b",
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
					"story_echo_morrow_04_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_04_c",
		response = "story_echo_morrow_04_c",
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
					"story_echo_morrow_04_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_04_d",
		response = "story_echo_morrow_04_d",
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
					"story_echo_morrow_04_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_05_a",
		response = "story_echo_morrow_05_a",
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
				"story_echo_morrow_05_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_05_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_05_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_05_b",
		response = "story_echo_morrow_05_b",
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
					"story_echo_morrow_05_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_05_c",
		response = "story_echo_morrow_05_c",
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
					"story_echo_morrow_05_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_05_d",
		response = "story_echo_morrow_05_d",
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
					"story_echo_morrow_05_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_05_e",
		response = "story_echo_morrow_05_e",
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
					"story_echo_morrow_05_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_06_a",
		response = "story_echo_morrow_06_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_legion_commissar_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_06_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_05_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_06_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_06_b",
		response = "story_echo_morrow_06_b",
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
					"story_echo_morrow_06_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_06_c",
		response = "story_echo_morrow_06_c",
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
					"story_echo_morrow_06_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_06_d",
		response = "story_echo_morrow_06_d",
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
					"story_echo_morrow_06_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_06_e",
		response = "story_echo_morrow_06_e",
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
					"story_echo_morrow_06_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_06_f",
		response = "story_echo_morrow_06_f",
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
					"story_echo_morrow_06_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_07_a",
		response = "story_echo_morrow_07_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_legion_trooper_b",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_07_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_06_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_07_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_07_b",
		response = "story_echo_morrow_07_b",
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
					"story_echo_morrow_07_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_07_c",
		response = "story_echo_morrow_07_c",
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
					"story_echo_morrow_07_b_disabled",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_07_d",
		response = "story_echo_morrow_07_d",
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
					"story_echo_morrow_07_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_07_e",
		response = "story_echo_morrow_07_e",
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
					"story_echo_morrow_07_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_07_f",
		response = "story_echo_morrow_07_f",
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
					"story_echo_morrow_07_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_07_g",
		response = "story_echo_morrow_07_g",
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
					"story_echo_morrow_07_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_08_a",
		response = "story_echo_morrow_08_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_legion_trooper_b",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_08_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_07_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_08_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_08_b",
		response = "story_echo_morrow_08_b",
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
					"story_echo_morrow_08_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_08_c",
		response = "story_echo_morrow_08_c",
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
					"story_echo_morrow_08_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_08_d",
		response = "story_echo_morrow_08_d",
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
					"story_echo_morrow_08_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_09_a",
		response = "story_echo_morrow_09_a",
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
				"story_echo_morrow_09_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_legion_trooper_b",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_09_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_09_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_09_b",
		response = "story_echo_morrow_09_b",
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
					"story_echo_morrow_09_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_09_c",
		response = "story_echo_morrow_09_c",
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
					"story_echo_morrow_09_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_09_d",
		response = "story_echo_morrow_09_d",
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
					"story_echo_morrow_09_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_09_e",
		response = "story_echo_morrow_09_e",
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
					"story_echo_morrow_09_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_09_f",
		response = "story_echo_morrow_09_f",
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
					"story_echo_morrow_09_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_10_a",
		response = "story_echo_morrow_10_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_legion_trooper_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_10_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_09_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_10_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_10_b",
		response = "story_echo_morrow_10_b",
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
					"story_echo_morrow_10_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_10_c",
		response = "story_echo_morrow_10_c",
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
					"story_echo_morrow_10_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_10_d",
		response = "story_echo_morrow_10_d",
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
					"story_echo_morrow_10_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_10_e",
		response = "story_echo_morrow_10_e",
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
					"story_echo_morrow_10_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_10_f",
		response = "story_echo_morrow_10_f",
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
					"story_echo_morrow_10_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_11_a",
		response = "story_echo_morrow_11_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_legion_commissar_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_11_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_10_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_11_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_11_b",
		response = "story_echo_morrow_11_b",
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
					"story_echo_morrow_11_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_11_c",
		response = "story_echo_morrow_11_c",
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
					"story_echo_morrow_11_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_11_d",
		response = "story_echo_morrow_11_d",
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
					"story_echo_morrow_11_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_11_e",
		response = "story_echo_morrow_11_e",
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
					"story_echo_morrow_11_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_11_f",
		response = "story_echo_morrow_11_f",
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
					"story_echo_morrow_11_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_12_a",
		response = "story_echo_morrow_12_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_12_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_11_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_12_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_12_b",
		response = "story_echo_morrow_12_b",
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
					"story_echo_morrow_12_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_12_c",
		response = "story_echo_morrow_12_c",
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
					"story_echo_morrow_12_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_12_d",
		response = "story_echo_morrow_12_d",
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
					"story_echo_morrow_12_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_12_e",
		response = "story_echo_morrow_12_e",
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
					"story_echo_morrow_12_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_13_a",
		response = "story_echo_morrow_13_a",
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
				"story_echo_morrow_13_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_b",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_13_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_13_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_13_b",
		response = "story_echo_morrow_13_b",
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
					"story_echo_morrow_13_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_13_c",
		response = "story_echo_morrow_13_c",
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
					"story_echo_morrow_13_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_13_d",
		response = "story_echo_morrow_13_d",
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
					"story_echo_morrow_13_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_13_e",
		response = "story_echo_morrow_13_e",
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
					"story_echo_morrow_13_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_13a_a",
		response = "story_echo_morrow_13a_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_b",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_13a_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_13_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_13a_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_13a_b",
		response = "story_echo_morrow_13a_b",
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
					"story_echo_morrow_13a_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_13a_c",
		response = "story_echo_morrow_13a_c",
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
					"story_echo_morrow_13a_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_13a_d",
		response = "story_echo_morrow_13a_d",
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
					"story_echo_morrow_13a_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_14_c",
		response = "story_echo_morrow_14_c",
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
					"story_echo_morrow_13a_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_14_d",
		response = "story_echo_morrow_14_d",
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
					"story_echo_morrow_14_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_14_e",
		response = "story_echo_morrow_14_e",
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
					"story_echo_morrow_14_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_15_a",
		response = "story_echo_morrow_15_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_b",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_15_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_13a_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_15_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_15_b",
		response = "story_echo_morrow_15_b",
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
					"story_echo_morrow_15_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_15_c",
		response = "story_echo_morrow_15_c",
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
					"story_echo_morrow_15_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_15_d",
		response = "story_echo_morrow_15_d",
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
					"story_echo_morrow_15_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_15_e",
		response = "story_echo_morrow_15_e",
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
					"story_echo_morrow_15_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_15_f",
		response = "story_echo_morrow_15_f",
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
					"story_echo_morrow_15_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_16_a",
		response = "story_echo_morrow_16_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_explicator_b",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_16_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_15_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_16_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_16_b",
		response = "story_echo_morrow_16_b",
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
					"story_echo_morrow_16_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_16_c",
		response = "story_echo_morrow_16_c",
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
					"story_echo_morrow_16_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_16_d",
		response = "story_echo_morrow_16_d",
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
					"story_echo_morrow_16_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_17_a",
		response = "story_echo_morrow_17_a",
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
				"story_echo_morrow_17_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_17_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_17_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_17_b",
		response = "story_echo_morrow_17_b",
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
					"story_echo_morrow_17_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_17_c",
		response = "story_echo_morrow_17_c",
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
					"story_echo_morrow_17_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_17_d",
		response = "story_echo_morrow_17_d",
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
					"story_echo_morrow_17_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_17_e",
		response = "story_echo_morrow_17_e",
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
					"story_echo_morrow_17_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_18_a",
		response = "story_echo_morrow_18_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_18_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_17_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_18_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_18_b",
		response = "story_echo_morrow_18_b",
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
					"story_echo_morrow_18_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_18_c",
		response = "story_echo_morrow_18_c",
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
					"story_echo_morrow_18_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_18_d",
		response = "story_echo_morrow_18_d",
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
					"story_echo_morrow_18_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_18_e",
		response = "story_echo_morrow_18_e",
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
					"story_echo_morrow_18_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_18_f",
		response = "story_echo_morrow_18_f",
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
					"story_echo_morrow_18_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_19_a",
		response = "story_echo_morrow_19_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_19_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_18_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_19_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_19_b",
		response = "story_echo_morrow_19_b",
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
					"story_echo_morrow_19_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_19_c",
		response = "story_echo_morrow_19_c",
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
					"story_echo_morrow_19_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_19_d",
		response = "story_echo_morrow_19_d",
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
					"story_echo_morrow_19_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_19_e",
		response = "story_echo_morrow_19_e",
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
					"story_echo_morrow_19_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_20_a",
		response = "story_echo_morrow_20_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_20_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_19_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_20_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_20_b",
		response = "story_echo_morrow_20_b",
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
					"story_echo_morrow_20_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_20_c",
		response = "story_echo_morrow_20_c",
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
					"story_echo_morrow_20_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_20_d",
		response = "story_echo_morrow_20_d",
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
					"story_echo_morrow_20_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_20_e",
		response = "story_echo_morrow_20_e",
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
					"story_echo_morrow_20_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_20_f",
		response = "story_echo_morrow_20_f",
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
					"story_echo_morrow_20_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_21_a",
		response = "story_echo_morrow_21_a",
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
				"story_echo_morrow_21_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_auspex_operator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_21_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_21_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_21_b",
		response = "story_echo_morrow_21_b",
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
					"story_echo_morrow_21_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_21_c",
		response = "story_echo_morrow_21_c",
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
					"story_echo_morrow_21_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_21_d",
		response = "story_echo_morrow_21_d",
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
					"story_echo_morrow_21_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_21_e",
		response = "story_echo_morrow_21_e",
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
					"story_echo_morrow_21_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_22_a",
		response = "story_echo_morrow_22_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_22_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_21_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_22_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_22_b",
		response = "story_echo_morrow_22_b",
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
					"story_echo_morrow_22_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_22_c",
		response = "story_echo_morrow_22_c",
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
					"story_echo_morrow_22_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_23_a",
		response = "story_echo_morrow_23_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_23_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_22_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_23_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_23_b",
		response = "story_echo_morrow_23_b",
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
					"story_echo_morrow_23_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_23_c",
		response = "story_echo_morrow_23_c",
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
					"story_echo_morrow_23_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_23_d",
		response = "story_echo_morrow_23_d",
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
					"story_echo_morrow_23_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_23_e",
		response = "story_echo_morrow_23_e",
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
					"story_echo_morrow_23_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_23_f",
		response = "story_echo_morrow_23_f",
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
					"story_echo_morrow_23_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_23_g",
		response = "story_echo_morrow_23_g",
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
					"story_echo_morrow_23_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_23_h",
		response = "story_echo_morrow_23_h",
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
					"story_echo_morrow_23_g",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_23_i",
		response = "story_echo_morrow_23_i",
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
					"story_echo_morrow_23_h",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_23_j",
		response = "story_echo_morrow_23_j",
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
					"story_echo_morrow_23_i",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_23_k",
		response = "story_echo_morrow_23_k",
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
					"story_echo_morrow_23_j",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_24_a",
		response = "story_echo_morrow_24_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_24_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_23_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_24_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_24_b",
		response = "story_echo_morrow_24_b",
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
					"story_echo_morrow_24_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_24_c",
		response = "story_echo_morrow_24_c",
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
					"story_echo_morrow_24_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_24_d",
		response = "story_echo_morrow_24_d",
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
					"story_echo_morrow_24_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_24_e",
		response = "story_echo_morrow_24_e",
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
					"story_echo_morrow_24_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_25_a",
		response = "story_echo_morrow_25_a",
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
				"story_echo_morrow_25_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_auspex_operator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_25_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_25_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_25_b",
		response = "story_echo_morrow_25_b",
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
					"story_echo_morrow_25_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_25_c",
		response = "story_echo_morrow_25_c",
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
					"story_echo_morrow_25_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_25_d",
		response = "story_echo_morrow_25_d",
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
					"story_echo_morrow_25_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_26_a",
		response = "story_echo_morrow_26_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_26_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_25_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_26_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_26_b",
		response = "story_echo_morrow_26_b",
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
					"story_echo_morrow_26_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_26_c",
		response = "story_echo_morrow_26_c",
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
					"story_echo_morrow_26_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_26_d",
		response = "story_echo_morrow_26_d",
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
					"story_echo_morrow_26_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_27_a",
		response = "story_echo_morrow_27_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_27_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_26_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_27_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_27_b",
		response = "story_echo_morrow_27_b",
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
					"story_echo_morrow_27_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_27_c",
		response = "story_echo_morrow_27_c",
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
					"story_echo_morrow_27_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_27_d",
		response = "story_echo_morrow_27_d",
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
					"story_echo_morrow_27_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_27_e",
		response = "story_echo_morrow_27_e",
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
					"story_echo_morrow_27_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_28_a",
		response = "story_echo_morrow_28_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_enemy_nemesis_wolfer_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_28_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_27_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_28_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_28_b",
		response = "story_echo_morrow_28_b",
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
					"story_echo_morrow_28_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_28_c",
		response = "story_echo_morrow_28_c",
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
					"story_echo_morrow_28_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_28_d",
		response = "story_echo_morrow_28_d",
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
					"story_echo_morrow_28_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_29_a",
		response = "story_echo_morrow_29_a",
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
				"story_echo_morrow_29_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_29_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_29_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_29_b",
		response = "story_echo_morrow_29_b",
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
					"story_echo_morrow_29_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_29_c",
		response = "story_echo_morrow_29_c",
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
					"story_echo_morrow_29_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_29_d",
		response = "story_echo_morrow_29_d",
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
					"story_echo_morrow_29_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_30_a",
		response = "story_echo_morrow_30_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_enemy_nemesis_wolfer_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_30_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_29_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_30_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_30_b",
		response = "story_echo_morrow_30_b",
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
					"story_echo_morrow_30_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_30_c",
		response = "story_echo_morrow_30_c",
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
					"story_echo_morrow_30_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_30_d",
		response = "story_echo_morrow_30_d",
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
					"story_echo_morrow_30_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_30_e",
		response = "story_echo_morrow_30_e",
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
					"story_echo_morrow_30_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_30_f",
		response = "story_echo_morrow_30_f",
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
					"story_echo_morrow_30_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_31_a",
		response = "story_echo_morrow_31_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_armourer_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_31_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_30_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_31_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_31_b",
		response = "story_echo_morrow_31_b",
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
					"story_echo_morrow_31_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_31_c",
		response = "story_echo_morrow_31_c",
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
					"story_echo_morrow_31_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_31_d",
		response = "story_echo_morrow_31_d",
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
					"story_echo_morrow_31_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_31_e",
		response = "story_echo_morrow_31_e",
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
					"story_echo_morrow_31_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_32_a",
		response = "story_echo_morrow_32_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_32_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_31_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_32_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_32_b",
		response = "story_echo_morrow_32_b",
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
					"story_echo_morrow_32_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_32_c",
		response = "story_echo_morrow_32_c",
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
					"story_echo_morrow_32_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_32_d",
		response = "story_echo_morrow_32_d",
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
					"story_echo_morrow_32_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_32_e",
		response = "story_echo_morrow_32_e",
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
					"story_echo_morrow_32_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_33_a",
		response = "story_echo_morrow_33_a",
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
				"story_echo_morrow_33_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_cartel_tough_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_33_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_33_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_33_b",
		response = "story_echo_morrow_33_b",
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
					"story_echo_morrow_33_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_33_c",
		response = "story_echo_morrow_33_c",
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
					"story_echo_morrow_33_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_33_d",
		response = "story_echo_morrow_33_d",
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
					"story_echo_morrow_33_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_33_e",
		response = "story_echo_morrow_33_e",
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
					"story_echo_morrow_33_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_33_f",
		response = "story_echo_morrow_33_f",
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
					"story_echo_morrow_33_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_34_a",
		response = "story_echo_morrow_34_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_34_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_33_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_34_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_34_b",
		response = "story_echo_morrow_34_b",
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
					"story_echo_morrow_34_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_34_c",
		response = "story_echo_morrow_34_c",
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
					"story_echo_morrow_34_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_34_d",
		response = "story_echo_morrow_34_d",
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
					"story_echo_morrow_34_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_34_e",
		response = "story_echo_morrow_34_e",
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
					"story_echo_morrow_34_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_34_f",
		response = "story_echo_morrow_34_f",
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
					"story_echo_morrow_34_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_34_g",
		response = "story_echo_morrow_34_g",
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
					"story_echo_morrow_34_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_35_a",
		response = "story_echo_morrow_35_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_armourer_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_35_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_34_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_35_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_35_b",
		response = "story_echo_morrow_35_b",
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
					"story_echo_morrow_35_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_35_c",
		response = "story_echo_morrow_35_c",
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
					"story_echo_morrow_35_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_35_d",
		response = "story_echo_morrow_35_d",
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
					"story_echo_morrow_35_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_35_e",
		response = "story_echo_morrow_35_e",
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
					"story_echo_morrow_35_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_35_f",
		response = "story_echo_morrow_35_f",
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
					"story_echo_morrow_35_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_35_g",
		response = "story_echo_morrow_35_g",
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
					"story_echo_morrow_35_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_36_a",
		response = "story_echo_morrow_36_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_36_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_35_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_36_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_36_b",
		response = "story_echo_morrow_36_b",
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
					"story_echo_morrow_36_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_36_c",
		response = "story_echo_morrow_36_c",
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
					"story_echo_morrow_36_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_36_d",
		response = "story_echo_morrow_36_d",
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
					"story_echo_morrow_36_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_36_e",
		response = "story_echo_morrow_36_e",
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
					"story_echo_morrow_36_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_39_a",
		response = "story_echo_morrow_39_a",
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
				"story_echo_morrow_39_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_comms_operator_c",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_39_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_39_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_39_b",
		response = "story_echo_morrow_39_b",
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
					"story_echo_morrow_39_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_39_c",
		response = "story_echo_morrow_39_c",
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
					"story_echo_morrow_39_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_39_d",
		response = "story_echo_morrow_39_d",
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
					"story_echo_morrow_39_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_39_e",
		response = "story_echo_morrow_39_e",
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
					"story_echo_morrow_39_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_39_f",
		response = "story_echo_morrow_39_f",
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
					"story_echo_morrow_39_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_39_g",
		response = "story_echo_morrow_39_g",
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
					"story_echo_morrow_39_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_40_a",
		response = "story_echo_morrow_40_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_40_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_39_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_40_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_40_b",
		response = "story_echo_morrow_40_b",
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
					"story_echo_morrow_40_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_40_c",
		response = "story_echo_morrow_40_c",
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
					"story_echo_morrow_40_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_40_d",
		response = "story_echo_morrow_40_d",
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
					"story_echo_morrow_40_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_40_e",
		response = "story_echo_morrow_40_e",
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
					"story_echo_morrow_40_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_40_f",
		response = "story_echo_morrow_40_f",
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
					"story_echo_morrow_40_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_41_a",
		response = "story_echo_morrow_41_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_41_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_40_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_41_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_41_b",
		response = "story_echo_morrow_41_b",
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
					"story_echo_morrow_41_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_41_c",
		response = "story_echo_morrow_41_c",
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
					"story_echo_morrow_41_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_41_d",
		response = "story_echo_morrow_41_d",
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
					"story_echo_morrow_41_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_41_e",
		response = "story_echo_morrow_41_e",
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
					"story_echo_morrow_41_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_41_f",
		response = "story_echo_morrow_41_f",
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
					"story_echo_morrow_41_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_42_a",
		response = "story_echo_morrow_42_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_comms_operator_c",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_42_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_41_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_42_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_42_b",
		response = "story_echo_morrow_42_b",
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
					"story_echo_morrow_42_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_42_c",
		response = "story_echo_morrow_42_c",
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
					"story_echo_morrow_42_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_42_d",
		response = "story_echo_morrow_42_d",
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
					"story_echo_morrow_42_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_42_e",
		response = "story_echo_morrow_42_e",
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
					"story_echo_morrow_42_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_42_f",
		response = "story_echo_morrow_42_f",
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
					"story_echo_morrow_42_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_42_g",
		response = "story_echo_morrow_42_g",
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
					"story_echo_morrow_42_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_43_a",
		response = "story_echo_morrow_43_a",
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
				"story_echo_morrow_43_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_43_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_43_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_43_b",
		response = "story_echo_morrow_43_b",
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
					"story_echo_morrow_43_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_43_c",
		response = "story_echo_morrow_43_c",
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
					"story_echo_morrow_43_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_43_d",
		response = "story_echo_morrow_43_d",
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
					"story_echo_morrow_43_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_43_e",
		response = "story_echo_morrow_43_e",
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
					"story_echo_morrow_43_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_43_f",
		response = "story_echo_morrow_43_f",
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
					"story_echo_morrow_43_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_43_g",
		response = "story_echo_morrow_43_g",
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
					"story_echo_morrow_43_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_44_a",
		response = "story_echo_morrow_44_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_commissar_a",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_44_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_43_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_44_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_44_b",
		response = "story_echo_morrow_44_b",
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
					"story_echo_morrow_44_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_44_c",
		response = "story_echo_morrow_44_c",
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
					"story_echo_morrow_44_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_44_d",
		response = "story_echo_morrow_44_d",
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
					"story_echo_morrow_44_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_44_e",
		response = "story_echo_morrow_44_e",
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
					"story_echo_morrow_44_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_44_f",
		response = "story_echo_morrow_44_f",
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
					"story_echo_morrow_44_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_44_g",
		response = "story_echo_morrow_44_g",
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
					"story_echo_morrow_44_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_45_a",
		response = "story_echo_morrow_45_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_comms_operator_c",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_45_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_44_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_45_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_45_b",
		response = "story_echo_morrow_45_b",
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
					"story_echo_morrow_45_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_45_c",
		response = "story_echo_morrow_45_c",
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
					"story_echo_morrow_45_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_45_d",
		response = "story_echo_morrow_45_d",
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
					"story_echo_morrow_45_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_45_e",
		response = "story_echo_morrow_45_e",
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
					"story_echo_morrow_45_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_45_f",
		response = "story_echo_morrow_45_f",
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
					"story_echo_morrow_45_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_45_g",
		response = "story_echo_morrow_45_g",
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
					"story_echo_morrow_45_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_46_a",
		response = "story_echo_morrow_46_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_comms_operator_c",
				},
			},
			{
				"faction_memory",
				"story_echo_morrow_46_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_morrow_45_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_morrow_46_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_46_b",
		response = "story_echo_morrow_46_b",
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
					"story_echo_morrow_46_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_46_c",
		response = "story_echo_morrow_46_c",
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
					"story_echo_morrow_46_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_46_d",
		response = "story_echo_morrow_46_d",
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
					"story_echo_morrow_46_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_46_e",
		response = "story_echo_morrow_46_e",
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
					"story_echo_morrow_46_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_morrow_46_f",
		response = "story_echo_morrow_46_f",
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
					"story_echo_morrow_46_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_01_a",
		response = "story_echo_zola_01_a",
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
				"story_echo_zola_01_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_young_explicator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_01_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_01_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_01_b",
		response = "story_echo_zola_01_b",
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
					"story_echo_zola_01_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_01_c",
		response = "story_echo_zola_01_c",
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
					"story_echo_zola_01_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_01_d",
		response = "story_echo_zola_01_d",
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
					"story_echo_zola_01_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_01_e",
		response = "story_echo_zola_01_e",
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
					"story_echo_zola_01_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_02_a",
		response = "story_echo_zola_02_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_cartel_tough_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_02_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_01_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_02_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_02_b",
		response = "story_echo_zola_02_b",
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
					"story_echo_zola_02_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_02_c",
		response = "story_echo_zola_02_c",
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
					"story_echo_zola_02_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_02_d",
		response = "story_echo_zola_02_d",
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
					"story_echo_zola_02_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_02_e",
		response = "story_echo_zola_02_e",
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
					"story_echo_zola_02_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_03_a",
		response = "story_echo_zola_03_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_young_explicator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_03_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_02_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_03_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_03_b",
		response = "story_echo_zola_03_b",
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
					"story_echo_zola_03_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_03_c",
		response = "story_echo_zola_03_c",
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
					"story_echo_zola_03_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_03_d",
		response = "story_echo_zola_03_d",
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
					"story_echo_zola_03_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_04_a",
		response = "story_echo_zola_04_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_young_explicator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_04_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_03_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_04_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_04_b",
		response = "story_echo_zola_04_b",
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
					"story_echo_zola_04_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_04_c",
		response = "story_echo_zola_04_c",
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
					"story_echo_zola_04_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_04_d",
		response = "story_echo_zola_04_d",
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
					"story_echo_zola_04_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_04_e",
		response = "story_echo_zola_04_e",
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
					"story_echo_zola_04_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_05_a",
		response = "story_echo_zola_05_a",
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
				"story_echo_zola_05_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_ragged_king_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_05_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_05_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_05_b",
		response = "story_echo_zola_05_b",
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
					"story_echo_zola_05_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_05_c",
		response = "story_echo_zola_05_c",
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
					"story_echo_zola_05_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_05_d",
		response = "story_echo_zola_05_d",
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
					"story_echo_zola_05_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_06_a",
		response = "story_echo_zola_06_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"fx",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_06_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_05_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_06_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_06_b",
		response = "story_echo_zola_06_b",
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
					"story_echo_zola_06_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_06_c",
		response = "story_echo_zola_06_c",
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
					"story_echo_zola_06_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_06_d",
		response = "story_echo_zola_06_d",
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
					"story_echo_zola_06_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_06_e",
		response = "story_echo_zola_06_e",
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
					"story_echo_zola_06_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_06_f",
		response = "story_echo_zola_06_f",
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
					"story_echo_zola_06_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_06_g",
		response = "story_echo_zola_06_g",
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
					"story_echo_zola_06_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_07_a",
		response = "story_echo_zola_07_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_07_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_06_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_07_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_07_b",
		response = "story_echo_zola_07_b",
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
					"story_echo_zola_07_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_07_c",
		response = "story_echo_zola_07_c",
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
					"story_echo_zola_07_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_07_d",
		response = "story_echo_zola_07_d",
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
					"story_echo_zola_07_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_07_e",
		response = "story_echo_zola_07_e",
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
					"story_echo_zola_07_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_08_a",
		response = "story_echo_zola_08_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_explicator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_08_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_07_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_08_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_08_b",
		response = "story_echo_zola_08_b",
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
					"story_echo_zola_08_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_08_c",
		response = "story_echo_zola_08_c",
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
					"story_echo_zola_08_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_08_d",
		response = "story_echo_zola_08_d",
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
					"story_echo_zola_08_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_08_e",
		response = "story_echo_zola_08_e",
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
					"story_echo_zola_08_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_09_a",
		response = "story_echo_zola_09_a",
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
				"story_echo_zola_09_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_09_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_09_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_09_b",
		response = "story_echo_zola_09_b",
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
					"story_echo_zola_09_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_09_c",
		response = "story_echo_zola_09_c",
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
					"story_echo_zola_09_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_09_d",
		response = "story_echo_zola_09_d",
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
					"story_echo_zola_09_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_10_a",
		response = "story_echo_zola_10_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"fx",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_10_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_09_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_10_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_10_b",
		response = "story_echo_zola_10_b",
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
					"story_echo_zola_10_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_10_c",
		response = "story_echo_zola_10_c",
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
					"story_echo_zola_10_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_10_d",
		response = "story_echo_zola_10_d",
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
					"story_echo_zola_10_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_10_e",
		response = "story_echo_zola_10_e",
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
					"story_echo_zola_10_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_10_f",
		response = "story_echo_zola_10_f",
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
					"story_echo_zola_10_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_10_g",
		response = "story_echo_zola_10_g",
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
					"story_echo_zola_10_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_11_a",
		response = "story_echo_zola_11_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_cartel_tough_c",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_11_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_10_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_11_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_11_b",
		response = "story_echo_zola_11_b",
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
					"story_echo_zola_11_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_11_c",
		response = "story_echo_zola_11_c",
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
					"story_echo_zola_11_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_11_d",
		response = "story_echo_zola_11_d",
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
					"story_echo_zola_11_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_11_e",
		response = "story_echo_zola_11_e",
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
					"story_echo_zola_11_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_12_a",
		response = "story_echo_zola_12_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_explicator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_12_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_11_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_12_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_12_b",
		response = "story_echo_zola_12_b",
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
					"story_echo_zola_12_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_12_c",
		response = "story_echo_zola_12_c",
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
					"story_echo_zola_12_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_12_d",
		response = "story_echo_zola_12_d",
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
					"story_echo_zola_12_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_12_e",
		response = "story_echo_zola_12_e",
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
					"story_echo_zola_12_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_13_a",
		response = "story_echo_zola_13_a",
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
				"story_echo_zola_13_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_explicator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_13_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_13_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_13_b",
		response = "story_echo_zola_13_b",
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
					"story_echo_zola_13_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_13_c",
		response = "story_echo_zola_13_c",
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
					"story_echo_zola_13_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_13_d",
		response = "story_echo_zola_13_d",
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
					"story_echo_zola_13_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_13_e",
		response = "story_echo_zola_13_e",
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
					"story_echo_zola_13_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_14_a",
		response = "story_echo_zola_14_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_explicator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_14_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_13_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_14_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_14_b",
		response = "story_echo_zola_14_b",
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
					"story_echo_zola_14_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_14_c",
		response = "story_echo_zola_14_c",
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
					"story_echo_zola_14_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_14_d",
		response = "story_echo_zola_14_d",
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
					"story_echo_zola_14_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_14_e",
		response = "story_echo_zola_14_e",
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
					"story_echo_zola_14_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_15_a",
		response = "story_echo_zola_15_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_15_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_14_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_15_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_15_b",
		response = "story_echo_zola_15_b",
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
					"story_echo_zola_15_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_15_c",
		response = "story_echo_zola_15_c",
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
					"story_echo_zola_15_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_15_d",
		response = "story_echo_zola_15_d",
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
					"story_echo_zola_15_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_15_e",
		response = "story_echo_zola_15_e",
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
					"story_echo_zola_15_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_16_a",
		response = "story_echo_zola_16_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_explicator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_16_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_15_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_16_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_16_b",
		response = "story_echo_zola_16_b",
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
					"story_echo_zola_16_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_16_c",
		response = "story_echo_zola_16_c",
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
					"story_echo_zola_16_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_16_d",
		response = "story_echo_zola_16_d",
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
					"story_echo_zola_16_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_16_e",
		response = "story_echo_zola_16_e",
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
					"story_echo_zola_16_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_16_f",
		response = "story_echo_zola_16_f",
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
					"story_echo_zola_16_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_16_g",
		response = "story_echo_zola_16_g",
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
					"story_echo_zola_16_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_16_h",
		response = "story_echo_zola_16_h",
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
					"story_echo_zola_16_g",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_16_i",
		response = "story_echo_zola_16_i",
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
					"story_echo_zola_16_h",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_17_a",
		response = "story_echo_zola_17_a",
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
				"story_echo_zola_17_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_explicator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_17_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_17_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_17_b",
		response = "story_echo_zola_17_b",
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
					"story_echo_zola_17_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_17_c",
		response = "story_echo_zola_17_c",
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
					"story_echo_zola_17_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_17_d",
		response = "story_echo_zola_17_d",
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
					"story_echo_zola_17_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_18_a",
		response = "story_echo_zola_18_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_18_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_17_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_18_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_18_b",
		response = "story_echo_zola_18_b",
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
					"story_echo_zola_18_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_18_c",
		response = "story_echo_zola_18_c",
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
					"story_echo_zola_18_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_18_d",
		response = "story_echo_zola_18_d",
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
					"story_echo_zola_18_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_18_e",
		response = "story_echo_zola_18_e",
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
					"story_echo_zola_18_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_19_a",
		response = "story_echo_zola_19_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_armourer_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_19_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_18_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_19_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_19_b",
		response = "story_echo_zola_19_b",
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
					"story_echo_zola_19_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_19_c",
		response = "story_echo_zola_19_c",
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
					"story_echo_zola_19_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_19_d",
		response = "story_echo_zola_19_d",
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
					"story_echo_zola_19_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_19_e",
		response = "story_echo_zola_19_e",
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
					"story_echo_zola_19_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_19_f",
		response = "story_echo_zola_19_f",
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
					"story_echo_zola_19_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_20_a",
		response = "story_echo_zola_20_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_ragged_king_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_20_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_19_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_20_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_20_b",
		response = "story_echo_zola_20_b",
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
					"story_echo_zola_20_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_20_c",
		response = "story_echo_zola_20_c",
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
					"story_echo_zola_20_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_20_d",
		response = "story_echo_zola_20_d",
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
					"story_echo_zola_20_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_20_e",
		response = "story_echo_zola_20_e",
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
					"story_echo_zola_20_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_20_f",
		response = "story_echo_zola_20_f",
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
					"story_echo_zola_20_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_20_g",
		response = "story_echo_zola_20_g",
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
					"story_echo_zola_20_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_21_a",
		response = "story_echo_zola_21_a",
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
				"story_echo_zola_21_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_explicator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_21_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_21_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_21_b",
		response = "story_echo_zola_21_b",
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
					"story_echo_zola_21_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_21_c",
		response = "story_echo_zola_21_c",
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
					"story_echo_zola_21_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_21_d",
		response = "story_echo_zola_21_d",
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
					"story_echo_zola_21_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_21_e",
		response = "story_echo_zola_21_e",
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
					"story_echo_zola_21_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_22_a",
		response = "story_echo_zola_22_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_ragged_king_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_22_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_21_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_22_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_22_b",
		response = "story_echo_zola_22_b",
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
					"story_echo_zola_22_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_22_c",
		response = "story_echo_zola_22_c",
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
					"story_echo_zola_22_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_22_d",
		response = "story_echo_zola_22_d",
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
					"story_echo_zola_22_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_22_e",
		response = "story_echo_zola_22_e",
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
					"story_echo_zola_22_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_22_f",
		response = "story_echo_zola_22_f",
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
					"story_echo_zola_22_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_23_a",
		response = "story_echo_zola_23_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_23_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_22_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_23_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_23_b",
		response = "story_echo_zola_23_b",
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
					"story_echo_zola_23_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_23_c",
		response = "story_echo_zola_23_c",
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
					"story_echo_zola_23_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_23_d",
		response = "story_echo_zola_23_d",
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
					"story_echo_zola_23_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_24_a",
		response = "story_echo_zola_24_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_explicator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_24_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_23_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_24_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_24_b",
		response = "story_echo_zola_24_b",
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
					"story_echo_zola_24_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_24_c",
		response = "story_echo_zola_24_c",
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
					"story_echo_zola_24_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_24_d",
		response = "story_echo_zola_24_d",
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
					"story_echo_zola_24_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_24_e",
		response = "story_echo_zola_24_e",
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
					"story_echo_zola_24_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_24_f",
		response = "story_echo_zola_24_f",
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
					"story_echo_zola_24_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_25_a",
		response = "story_echo_zola_25_a",
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
				"story_echo_zola_25_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_25_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_25_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "self",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_25_b",
		response = "story_echo_zola_25_b",
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
					"story_echo_zola_25_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_25_c",
		response = "story_echo_zola_25_c",
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
					"story_echo_zola_25_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_25_d",
		response = "story_echo_zola_25_d",
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
					"story_echo_zola_25_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_25_e",
		response = "story_echo_zola_25_e",
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
					"story_echo_zola_25_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_26_a",
		response = "story_echo_zola_26_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_26_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_25_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_26_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_26_b",
		response = "story_echo_zola_26_b",
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
					"story_echo_zola_26_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_26_c",
		response = "story_echo_zola_26_c",
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
					"story_echo_zola_26_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_26_d",
		response = "story_echo_zola_26_d",
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
					"story_echo_zola_26_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_26_e",
		response = "story_echo_zola_26_e",
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
					"story_echo_zola_26_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_27_a",
		response = "story_echo_zola_27_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_27_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_26_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_27_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_27_b",
		response = "story_echo_zola_27_b",
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
					"story_echo_zola_27_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_27_c",
		response = "story_echo_zola_27_c",
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
					"story_echo_zola_27_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_27_d",
		response = "story_echo_zola_27_d",
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
					"story_echo_zola_27_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_27_e",
		response = "story_echo_zola_27_e",
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
					"story_echo_zola_27_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_28_a",
		response = "story_echo_zola_28_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_28_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_27_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_28_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_28_b",
		response = "story_echo_zola_28_b",
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
					"story_echo_zola_28_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_28_c",
		response = "story_echo_zola_28_c",
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
					"story_echo_zola_28_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_28_d",
		response = "story_echo_zola_28_d",
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
					"story_echo_zola_28_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_28_e",
		response = "story_echo_zola_28_e",
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
					"story_echo_zola_28_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_31_a",
		response = "story_echo_zola_31_a",
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
				"story_echo_zola_31_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_tech_priest_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_31_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_31_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_31_b",
		response = "story_echo_zola_31_b",
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
					"story_echo_zola_31_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_31_c",
		response = "story_echo_zola_31_c",
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
					"story_echo_zola_31_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_31_d",
		response = "story_echo_zola_31_d",
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
					"story_echo_zola_31_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_31_e",
		response = "story_echo_zola_31_e",
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
					"story_echo_zola_31_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_32_a",
		response = "story_echo_zola_32_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_explicator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_32_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_31_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_32_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_32_b",
		response = "story_echo_zola_32_b",
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
					"story_echo_zola_32_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_32_c",
		response = "story_echo_zola_32_c",
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
					"story_echo_zola_32_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_32_d",
		response = "story_echo_zola_32_d",
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
					"story_echo_zola_32_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_32_e",
		response = "story_echo_zola_32_e",
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
					"story_echo_zola_32_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_32_f",
		response = "story_echo_zola_32_f",
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
					"story_echo_zola_32_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_32_g",
		response = "story_echo_zola_32_g",
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
					"story_echo_zola_32_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_33_a",
		response = "story_echo_zola_33_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_33_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_32_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_33_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_33_b",
		response = "story_echo_zola_33_b",
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
					"story_echo_zola_33_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_33_c",
		response = "story_echo_zola_33_c",
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
					"story_echo_zola_33_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_33_d",
		response = "story_echo_zola_33_d",
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
					"story_echo_zola_33_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_33_e",
		response = "story_echo_zola_33_e",
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
					"story_echo_zola_33_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_34_a",
		response = "story_echo_zola_34_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_sergeant_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_34_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_33_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_34_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_34_b",
		response = "story_echo_zola_34_b",
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
					"story_echo_zola_34_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_34_c",
		response = "story_echo_zola_34_c",
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
					"story_echo_zola_34_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_34_d",
		response = "story_echo_zola_34_d",
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
					"story_echo_zola_34_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_34_e",
		response = "story_echo_zola_34_e",
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
					"story_echo_zola_34_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_34_f",
		response = "story_echo_zola_34_f",
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
					"story_echo_zola_34_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_34_g",
		response = "story_echo_zola_34_g",
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
					"story_echo_zola_34_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_35_a",
		response = "story_echo_zola_35_a",
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
				"story_echo_zola_35_a",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_35_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_35_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_35_b",
		response = "story_echo_zola_35_b",
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
					"story_echo_zola_35_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_35_c",
		response = "story_echo_zola_35_c",
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
					"story_echo_zola_35_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_36_a",
		response = "story_echo_zola_36_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_interrogator_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_36_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_35_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_36_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_36_b",
		response = "story_echo_zola_36_b",
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
					"story_echo_zola_36_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_36_c",
		response = "story_echo_zola_36_c",
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
					"story_echo_zola_36_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_36_d",
		response = "story_echo_zola_36_d",
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
					"story_echo_zola_36_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_36_e",
		response = "story_echo_zola_36_e",
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
					"story_echo_zola_36_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_36_f",
		response = "story_echo_zola_36_f",
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
					"story_echo_zola_36_e",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_36_g",
		response = "story_echo_zola_36_g",
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
					"story_echo_zola_36_f",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_37_a",
		response = "story_echo_zola_37_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_auric_female_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_37_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_36_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_37_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_37_b",
		response = "story_echo_zola_37_b",
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
					"story_echo_zola_37_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_37_c",
		response = "story_echo_zola_37_c",
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
					"story_echo_zola_37_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_37_d",
		response = "story_echo_zola_37_d",
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
					"story_echo_zola_37_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_38_a",
		response = "story_echo_zola_38_a",
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
				"story_echo",
			},
			{
				"user_context",
				"voice_template",
				OP.SET_INCLUDES,
				args = {
					"past_auric_female_a",
				},
			},
			{
				"faction_memory",
				"story_echo_zola_38_a",
				OP.EQ,
				0,
			},
			{
				"faction_memory",
				"story_echo_zola_37_a",
				OP.EQ,
				1,
			},
		},
		on_done = {
			{
				"faction_memory",
				"story_echo_zola_38_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "mission_givers",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_38_b",
		response = "story_echo_zola_38_b",
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
					"story_echo_zola_38_a",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_38_c",
		response = "story_echo_zola_38_c",
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
					"story_echo_zola_38_b",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_38_d",
		response = "story_echo_zola_38_d",
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
					"story_echo_zola_38_c",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
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
		database = "mission_vo_psykhanium",
		name = "story_echo_zola_38_e",
		response = "story_echo_zola_38_e",
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
					"story_echo_zola_38_d",
				},
			},
			{
				"user_context",
				"class_name",
				OP.SET_INCLUDES,
				args = {
					"past",
				},
			},
		},
		on_done = {},
		heard_speak_routing = {
			target = "level_event_generic",
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "wave_start_armored_infected_a",
		response = "wave_start_armored_infected_a",
		wwise_route = 42,
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
				"wave_start_armored_infected_a",
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
				"faction_memory",
				"wave_start_armored_infected_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"wave_start_armored_infected_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "wave_start_chaos_ogryn_a",
		response = "wave_start_chaos_ogryn_a",
		wwise_route = 42,
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
				"wave_start_chaos_ogryn_a",
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
				"faction_memory",
				"wave_start_chaos_ogryn_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"wave_start_chaos_ogryn_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "wave_start_daemonhost_a",
		response = "wave_start_daemonhost_a",
		wwise_route = 42,
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
				"wave_start_daemonhost_a",
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
				"faction_memory",
				"wave_start_daemonhost_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"wave_start_daemonhost_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "wave_start_flamers_a",
		response = "wave_start_flamers_a",
		wwise_route = 42,
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
				"wave_start_flamers_a",
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
				"faction_memory",
				"wave_start_flamers_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"wave_start_flamers_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "wave_start_hounds_a",
		response = "wave_start_hounds_a",
		wwise_route = 42,
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
				"wave_start_hounds_a",
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
				"faction_memory",
				"wave_start_hounds_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"wave_start_hounds_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "wave_start_monsters_a",
		response = "wave_start_monsters_a",
		wwise_route = 42,
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
				"wave_start_monsters_a",
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
				"faction_memory",
				"wave_start_monsters_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"wave_start_monsters_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "wave_start_mutants_a",
		response = "wave_start_mutants_a",
		wwise_route = 42,
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
				"wave_start_mutants_a",
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
				"faction_memory",
				"wave_start_mutants_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"wave_start_mutants_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "wave_start_netgunner_a",
		response = "wave_start_netgunner_a",
		wwise_route = 42,
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
				"wave_start_netgunner_a",
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
				"faction_memory",
				"wave_start_netgunner_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"wave_start_netgunner_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "wave_start_poxbursters_a",
		response = "wave_start_poxbursters_a",
		wwise_route = 42,
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
				"wave_start_poxbursters_a",
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
				"faction_memory",
				"wave_start_poxbursters_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"wave_start_poxbursters_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "wave_start_snipers_a",
		response = "wave_start_snipers_a",
		wwise_route = 42,
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
				"wave_start_snipers_a",
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
				"faction_memory",
				"wave_start_snipers_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"wave_start_snipers_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
	define_rule({
		category = "vox_prio_0",
		database = "mission_vo_psykhanium",
		name = "wave_start_twins_a",
		response = "wave_start_twins_a",
		wwise_route = 42,
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
				"wave_start_twins_a",
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
				"faction_memory",
				"wave_start_twins_a",
				OP.EQ,
				0,
			},
		},
		on_done = {
			{
				"faction_memory",
				"wave_start_twins_a",
				OP.ADD,
				1,
			},
		},
		heard_speak_routing = {
			target = "disabled",
		},
		on_pre_rule_execution = {
			random_ignore_vo = {
				chance = 0.5,
				hold_for = 0,
				max_failed_tries = 0,
			},
		},
	})
end
