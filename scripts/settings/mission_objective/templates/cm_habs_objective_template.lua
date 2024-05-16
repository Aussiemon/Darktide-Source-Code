-- chunkname: @scripts/settings/mission_objective/templates/cm_habs_objective_template.lua

local mission_objective_templates = {
	cm_habs = {
		main_objective_type = "control_objective",
		objectives = {
			objective_cm_habs_cross_street = {
				description = "loc_objective_cm_habs_cross_street_desc",
				header = "loc_objective_cm_habs_cross_street_header",
				mission_objective_type = "goal",
			},
			objective_cm_habs_lobby_gate = {
				description = "loc_objective_cm_habs_lobby_gate_desc",
				header = "loc_objective_cm_habs_lobby_gate_header",
				mission_objective_type = "goal",
			},
			objective_cm_habs_find_first = {
				description = "loc_objective_cm_habs_find_first_desc",
				header = "loc_objective_cm_habs_find_first_header",
				mission_objective_type = "goal",
			},
			objective_cm_habs_scan_hab_a = {
				description = "loc_objective_cm_habs_scan_hab_a_desc",
				event_type = "mid_event",
				header = "loc_objective_cm_habs_scan_hab_a_header",
				mission_objective_type = "scanning",
				show_progression_popup_on_update = false,
				use_music_event = "scanning_event",
			},
			objective_cm_habs_to_pipe = {
				description = "loc_objective_cm_habs_to_pipe_desc",
				header = "loc_objective_cm_habs_to_pipe_header",
				mission_objective_type = "goal",
			},
			objective_cm_habs_hab_b_interrogators = {
				description = "loc_objective_cm_habs_hab_b_interrogators_desc",
				event_type = "end_event",
				header = "loc_objective_cm_habs_hab_b_interrogators_header",
				mission_objective_type = "decode",
				progress_bar = true,
				turn_off_backfill = true,
				use_music_event = "hacking_event",
			},
			objective_cm_habs_b_wait = {
				description = "loc_objective_cm_habs_b_wait_poison_desc",
				header = "loc_objective_cm_habs_b_wait_poison_header",
				mission_objective_type = "goal",
			},
			objective_cm_habs_to_deck = {
				description = "loc_objective_cm_habs_to_deck_desc",
				header = "loc_objective_cm_habs_to_deck_header",
				mission_objective_type = "goal",
				use_music_event = "escape_event",
			},
		},
	},
}

return mission_objective_templates
