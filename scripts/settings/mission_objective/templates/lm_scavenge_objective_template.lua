-- chunkname: @scripts/settings/mission_objective/templates/lm_scavenge_objective_template.lua

local mission_objective_templates = {
	lm_scavenge = {
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
				description = "loc_objective_lm_scavenge_decrypt_desc",
				music_wwise_state = "hacking_event",
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
				music_wwise_state = "collect_event",
				collect_amount = 3,
				header = "loc_objective_lm_scavenge_deposit_assets_header",
				event_type = "end_event",
				mission_objective_type = "luggable"
			},
			objective_lm_scavenge_send_assets = {
				description = "loc_objective_lm_scavenge_send_assets_desc",
				music_wwise_state = "end_event",
				mission_objective_type = "goal",
				header = "loc_objective_lm_scavenge_send_assets_header"
			},
			objective_lm_scavenge_escape = {
				description = "loc_objective_lm_scavenge_escape_desc",
				music_wwise_state = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_lm_scavenge_escape_header"
			},
			objective_lm_scavenge_luggable_secret = {
				mission_objective_type = "luggable",
				hidden = true
			}
		}
	}
}

return mission_objective_templates
