local mission_objective_templates = {
	lm_scavenge = {
		main_objective_type = "luggable_objective",
		objectives = {
			objective_lm_scavenge_leave_start = {
				description = "loc_objective_lm_scavenge_leave_start_desc",
				mission_objective_type = "goal",
				header = "loc_objective_lm_scavenge_leave_start_header"
			},
			objective_lm_scavenge_lower_platform = {
				description = "loc_objective_lm_scavenge_lower_platform_desc",
				mission_objective_type = "goal",
				header = "loc_objective_lm_scavenge_lower_platform_header"
			},
			objective_lm_scavenge_find_location = {
				description = "loc_objective_lm_scavenge_find_location_desc",
				mission_objective_type = "goal",
				header = "loc_objective_lm_scavenge_find_location_header"
			},
			objective_lm_scavenge_decrypt = {
				use_music_event = "hacking_event",
				description = "loc_objective_lm_scavenge_decrypt_desc",
				header = "loc_objective_lm_scavenge_decrypt_header",
				event_type = "mid_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_lm_scavenge_proceed_hangars = {
				description = "loc_objective_lm_scavenge_proceed_hangars_desc",
				mission_objective_type = "goal",
				header = "loc_objective_lm_scavenge_proceed_hangars_header"
			},
			objective_lm_scavenge_reach_vault = {
				description = "loc_objective_lm_scavenge_reach_vault_desc",
				mission_objective_type = "goal",
				header = "loc_objective_lm_scavenge_reach_vault_header"
			},
			objective_lm_scavenge_interact_vaults_panel = {
				description = "loc_objective_lm_scavenge_interact_vaults_panel_desc",
				turn_off_backfill = true,
				mission_objective_type = "goal",
				header = "loc_objective_lm_scavenge_interact_vaults_panel_header"
			},
			objective_lm_scavenge_deposit_assets = {
				description = "loc_objective_lm_scavenge_deposit_assets_desc",
				use_music_event = "collect_event",
				collect_amount = 3,
				header = "loc_objective_lm_scavenge_deposit_assets_header",
				event_type = "end_event",
				mission_objective_type = "luggable"
			},
			objective_lm_scavenge_send_assets = {
				description = "loc_objective_lm_scavenge_send_assets_desc",
				use_music_event = "end_event",
				mission_objective_type = "goal",
				header = "loc_objective_lm_scavenge_send_assets_header"
			},
			objective_lm_scavenge_escape = {
				description = "loc_objective_lm_scavenge_escape_desc",
				use_music_event = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_lm_scavenge_escape_header"
			}
		}
	}
}

return mission_objective_templates
