-- chunkname: @scripts/settings/mission_objective/templates/cm_habs_objective_template.lua

local mission_objective_templates = {
	cm_habs = {
		objectives = {
			objective_cm_habs_cross_street = {
				description = "loc_objective_cm_habs_cross_street_desc",
				mission_objective_type = "goal",
				header = "loc_objective_cm_habs_cross_street_header"
			},
			objective_cm_habs_lobby_gate = {
				description = "loc_objective_cm_habs_lobby_gate_desc",
				mission_objective_type = "goal",
				header = "loc_objective_cm_habs_lobby_gate_header"
			},
			objective_cm_habs_find_first = {
				description = "loc_objective_cm_habs_find_first_desc",
				mission_objective_type = "goal",
				header = "loc_objective_cm_habs_find_first_header"
			},
			objective_cm_habs_scan_hab_a = {
				description = "loc_objective_cm_habs_scan_hab_a_desc",
				music_wwise_state = "scanning_event",
				show_progression_popup_on_update = false,
				header = "loc_objective_cm_habs_scan_hab_a_header",
				event_type = "mid_event",
				mission_objective_type = "scanning"
			},
			objective_cm_habs_to_pipe = {
				description = "loc_objective_cm_habs_to_pipe_desc",
				mission_objective_type = "goal",
				header = "loc_objective_cm_habs_to_pipe_header"
			},
			objective_cm_habs_hab_b_interrogators = {
				description = "loc_objective_cm_habs_hab_b_interrogators_desc",
				music_wwise_state = "hacking_event",
				turn_off_backfill = true,
				header = "loc_objective_cm_habs_hab_b_interrogators_header",
				event_type = "end_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_cm_habs_b_wait = {
				description = "loc_objective_cm_habs_b_wait_poison_desc",
				mission_objective_type = "goal",
				header = "loc_objective_cm_habs_b_wait_poison_header"
			},
			objective_cm_habs_to_deck = {
				description = "loc_objective_cm_habs_to_deck_desc",
				music_wwise_state = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_cm_habs_to_deck_header"
			}
		}
	}
}

return mission_objective_templates
