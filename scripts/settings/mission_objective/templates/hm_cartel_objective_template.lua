-- chunkname: @scripts/settings/mission_objective/templates/hm_cartel_objective_template.lua

local mission_objective_templates = {
	hm_cartel = {
		objectives = {
			objective_hm_cartel_enter_slum = {
				description = "loc_objective_hm_cartel_enter_slum_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_cartel_enter_slum_header"
			},
			objective_hm_cartel_find_bazaar = {
				description = "loc_objective_hm_cartel_find_bazaar_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_cartel_find_bazaar_header"
			},
			objective_hm_cartel_locate_scanner = {
				description = "loc_objective_hm_cartel_locate_scanner_desc",
				music_wwise_state = "None",
				mission_objective_type = "goal",
				header = "loc_objective_hm_cartel_locate_scanner_header"
			},
			objective_hm_cartel_scan_bodies = {
				description = "loc_objective_hm_cartel_scan_bodies_desc",
				music_wwise_state = "scanning_event",
				mission_giver_voice_profile = "tech_priest_a",
				header = "loc_objective_hm_cartel_scan_bodies_header",
				show_progression_popup_on_update = false,
				event_type = "mid_event",
				mission_objective_type = "scanning"
			},
			objective_hm_cartel_wait_elevator = {
				description = "loc_objective_hm_cartel_wait_elevator_desc",
				music_wwise_state = "scanning_event",
				progress_bar = true,
				header = "loc_objective_hm_cartel_wait_elevator_header",
				event_type = "mid_event",
				duration = 45,
				mission_objective_type = "timed"
			},
			objective_hm_cartel_elevator = {
				description = "loc_objective_hm_cartel_elevator_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_cartel_elevator_header"
			},
			objective_hm_cartel_elevator_ride = {
				description = "loc_objective_hm_cartel_elevator_ride_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_cartel_elevator_ride_header"
			},
			objective_hm_cartel_find_datacenter = {
				description = "loc_objective_hm_cartel_find_datacenter_desc",
				mission_objective_type = "goal",
				header = "loc_objective_hm_cartel_find_datacenter_header"
			},
			objective_hm_cartel_interact_deactivate_first_protocol = {
				description = "loc_objective_hm_cartel_interact_deactivate_first_protocol_desc",
				turn_off_backfill = true,
				mission_objective_type = "goal",
				header = "loc_objective_hm_cartel_interact_deactivate_first_protocol_header"
			},
			objective_hm_cartel_deactivate_second_protocol = {
				description = "loc_objective_hm_cartel_deactivate_second_protocol_desc",
				music_wwise_state = "hacking_event",
				header = "loc_objective_hm_cartel_deactivate_second_protocol_header",
				event_type = "end_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_hm_cartel_first_interact_deactivate_second_protocol = {
				description = "loc_objective_hm_cartel_first_interact_deactivate_second_protocol_desc",
				music_wwise_state = "hacking_event",
				header = "loc_objective_hm_cartel_first_interact_deactivate_second_protocol_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_hm_cartel_second_interact_deactivate_second_protocol = {
				description = "loc_objective_hm_cartel_second_interact_deactivate_second_protocol_desc",
				music_wwise_state = "hacking_event",
				header = "loc_objective_hm_cartel_second_interact_deactivate_second_protocol_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_hm_cartel_plant_misinformation_data = {
				description = "loc_objective_hm_cartel_plant_misinformation_data_desc",
				music_wwise_state = "hacking_event",
				header = "loc_objective_hm_cartel_plant_misinformation_data_header",
				event_type = "end_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_hm_cartel_extract = {
				description = "loc_objective_hm_cartel_extract_desc",
				music_wwise_state = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_hm_cartel_extract_header"
			}
		}
	}
}

return mission_objective_templates
