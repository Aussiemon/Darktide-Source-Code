-- chunkname: @scripts/settings/mission_objective/templates/lm_scavenge_objective_template.lua

local mission_objective_templates = {
	lm_scavenge = {
		objectives = {
			objective_lm_scavenge_leave_start = {
				description = "loc_objective_lm_scavenge_leave_start_desc",
				header = "loc_objective_lm_scavenge_leave_start_header",
				mission_objective_type = "goal",
			},
			objective_lm_scavenge_lower_platform = {
				description = "loc_objective_lm_scavenge_lower_platform_desc",
				header = "loc_objective_lm_scavenge_lower_platform_header",
				mission_objective_type = "goal",
			},
			objective_lm_scavenge_find_location = {
				description = "loc_objective_lm_scavenge_find_location_desc",
				header = "loc_objective_lm_scavenge_find_location_header",
				mission_objective_type = "goal",
			},
			objective_lm_scavenge_decrypt = {
				description = "loc_objective_lm_scavenge_decrypt_desc",
				event_type = "mid_event",
				header = "loc_objective_lm_scavenge_decrypt_header",
				mission_objective_type = "decode",
				music_wwise_state = "hacking_event",
				progress_bar = true,
			},
			objective_lm_scavenge_proceed_hangars = {
				description = "loc_objective_lm_scavenge_proceed_hangars_desc",
				header = "loc_objective_lm_scavenge_proceed_hangars_header",
				mission_objective_type = "goal",
			},
			objective_lm_scavenge_reach_vault = {
				description = "loc_objective_lm_scavenge_reach_vault_desc",
				header = "loc_objective_lm_scavenge_reach_vault_header",
				mission_objective_type = "goal",
			},
			objective_lm_scavenge_interact_vaults_panel = {
				description = "loc_objective_lm_scavenge_interact_vaults_panel_desc",
				header = "loc_objective_lm_scavenge_interact_vaults_panel_header",
				mission_objective_type = "goal",
				turn_off_backfill = true,
			},
			objective_lm_scavenge_deposit_assets = {
				collect_amount = 3,
				description = "loc_objective_lm_scavenge_deposit_assets_desc",
				event_type = "end_event",
				header = "loc_objective_lm_scavenge_deposit_assets_header",
				mission_objective_type = "luggable",
				music_wwise_state = "collect_event",
			},
			objective_lm_scavenge_send_assets = {
				description = "loc_objective_lm_scavenge_send_assets_desc",
				header = "loc_objective_lm_scavenge_send_assets_header",
				mission_objective_type = "goal",
				music_wwise_state = "end_event",
			},
			objective_lm_scavenge_escape = {
				description = "loc_objective_lm_scavenge_escape_desc",
				header = "loc_objective_lm_scavenge_escape_header",
				mission_objective_type = "goal",
				music_wwise_state = "escape_event",
			},
			objective_lm_scavenge_luggable_secret = {
				hidden = true,
				mission_objective_type = "luggable",
			},
		},
	},
}

return mission_objective_templates
