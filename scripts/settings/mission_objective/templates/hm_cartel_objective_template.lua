-- chunkname: @scripts/settings/mission_objective/templates/hm_cartel_objective_template.lua

local mission_objective_templates = {
	hm_cartel = {
		objectives = {
			objective_hm_cartel_enter_slum = {
				description = "loc_objective_hm_cartel_enter_slum_desc",
				header = "loc_objective_hm_cartel_enter_slum_header",
				mission_objective_type = "goal",
			},
			objective_hm_cartel_find_bazaar = {
				description = "loc_objective_hm_cartel_find_bazaar_desc",
				header = "loc_objective_hm_cartel_find_bazaar_header",
				mission_objective_type = "goal",
			},
			objective_hm_cartel_locate_scanner = {
				description = "loc_objective_hm_cartel_locate_scanner_desc",
				header = "loc_objective_hm_cartel_locate_scanner_header",
				mission_objective_type = "goal",
				music_wwise_state = "None",
			},
			objective_hm_cartel_scan_bodies = {
				description = "loc_objective_hm_cartel_scan_bodies_desc",
				event_type = "mid_event",
				header = "loc_objective_hm_cartel_scan_bodies_header",
				mission_giver_voice_profile = "tech_priest_a",
				mission_objective_type = "scanning",
				music_wwise_state = "scanning_event",
				show_progression_popup_on_update = false,
			},
			objective_hm_cartel_wait_elevator = {
				description = "loc_objective_hm_cartel_wait_elevator_desc",
				duration = 45,
				event_type = "mid_event",
				header = "loc_objective_hm_cartel_wait_elevator_header",
				mission_objective_type = "timed",
				music_wwise_state = "scanning_event",
				progress_bar = true,
			},
			objective_hm_cartel_elevator = {
				description = "loc_objective_hm_cartel_elevator_desc",
				header = "loc_objective_hm_cartel_elevator_header",
				mission_objective_type = "goal",
			},
			objective_hm_cartel_elevator_ride = {
				description = "loc_objective_hm_cartel_elevator_ride_desc",
				header = "loc_objective_hm_cartel_elevator_ride_header",
				mission_objective_type = "goal",
			},
			objective_hm_cartel_find_datacenter = {
				description = "loc_objective_hm_cartel_find_datacenter_desc",
				header = "loc_objective_hm_cartel_find_datacenter_header",
				mission_objective_type = "goal",
			},
			objective_hm_cartel_interact_deactivate_first_protocol = {
				description = "loc_objective_hm_cartel_interact_deactivate_first_protocol_desc",
				header = "loc_objective_hm_cartel_interact_deactivate_first_protocol_header",
				mission_objective_type = "goal",
				turn_off_backfill = true,
			},
			objective_hm_cartel_deactivate_second_protocol = {
				description = "loc_objective_hm_cartel_deactivate_second_protocol_desc",
				event_type = "end_event",
				header = "loc_objective_hm_cartel_deactivate_second_protocol_header",
				mission_objective_type = "decode",
				music_wwise_state = "hacking_event",
				progress_bar = true,
			},
			objective_hm_cartel_first_interact_deactivate_second_protocol = {
				description = "loc_objective_hm_cartel_first_interact_deactivate_second_protocol_desc",
				event_type = "end_event",
				header = "loc_objective_hm_cartel_first_interact_deactivate_second_protocol_header",
				mission_objective_type = "goal",
				music_wwise_state = "hacking_event",
			},
			objective_hm_cartel_second_interact_deactivate_second_protocol = {
				description = "loc_objective_hm_cartel_second_interact_deactivate_second_protocol_desc",
				event_type = "end_event",
				header = "loc_objective_hm_cartel_second_interact_deactivate_second_protocol_header",
				mission_objective_type = "goal",
				music_wwise_state = "hacking_event",
			},
			objective_hm_cartel_plant_misinformation_data = {
				description = "loc_objective_hm_cartel_plant_misinformation_data_desc",
				event_type = "end_event",
				header = "loc_objective_hm_cartel_plant_misinformation_data_header",
				mission_objective_type = "decode",
				music_wwise_state = "hacking_event",
				progress_bar = true,
			},
			objective_hm_cartel_extract = {
				description = "loc_objective_hm_cartel_extract_desc",
				header = "loc_objective_hm_cartel_extract_header",
				mission_objective_type = "goal",
				music_wwise_state = "escape_event",
			},
		},
	},
}

return mission_objective_templates
