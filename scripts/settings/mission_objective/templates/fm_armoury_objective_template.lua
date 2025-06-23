-- chunkname: @scripts/settings/mission_objective/templates/fm_armoury_objective_template.lua

local mission_objective_templates = {
	fm_armoury = {
		objectives = {
			objective_fm_armoury_gauntlet_start = {
				description = "loc_objective_fm_armoury_gauntlet_start_desc",
				music_wwise_state = "gauntlet_event",
				header = "loc_objective_fm_armoury_gauntlet_start_header",
				event_type = "mid_event",
				mission_objective_type = "goal"
			},
			objective_fm_armoury_gauntlet_secure_intel = {
				description = "loc_objective_fm_armoury_secure_intel_desc",
				progress_bar = true,
				music_wwise_state = "gauntlet_event",
				header = "loc_objective_fm_armoury_secure_intel_header",
				event_type = "mid_event",
				duration = 80,
				mission_objective_type = "decode"
			},
			objective_fm_armoury_confirm_intel = {
				description = "loc_objective_fm_armoury_confirm_intel_desc",
				music_wwise_state = "gauntlet_event",
				header = "loc_objective_fm_armoury_confirm_intel_header",
				event_type = "mid_event",
				mission_objective_type = "goal",
				music_ignore_start_event = true
			},
			objective_fm_armoury_proceed = {
				description = "loc_objective_fm_armoury_proceed_desc",
				mission_objective_type = "goal",
				header = "loc_objective_fm_armoury_proceed_header"
			},
			objective_fm_armoury_brewery = {
				description = "loc_objective_fm_armoury_brewery_desc",
				mission_objective_type = "goal",
				header = "loc_objective_fm_armoury_brewery_header"
			},
			objective_fm_armoury_enter_black_market_area = {
				description = "loc_objective_fm_armoury_enter_black_market_area_header",
				mission_objective_type = "goal",
				header = "loc_objective_fm_armoury_enter_black_market_area_header"
			},
			objective_fm_armoury_find_stims = {
				description = "loc_objective_fm_armoury_find_stims_desc",
				turn_off_backfill = true,
				mission_objective_type = "goal",
				header = "loc_objective_fm_armoury_find_stims_header"
			},
			objective_fm_armoury_open_roof = {
				description = "loc_objective_fm_armoury_open_roof_desc",
				music_wwise_state = "fortification_event",
				turn_off_backfill = true,
				header = "loc_objective_fm_armoury_open_roof_header",
				event_type = "end_event",
				mission_objective_type = "goal",
				music_ignore_start_event = true
			},
			objective_fm_armoury_wait_for_roof = {
				description = "loc_objective_fm_armoury_wait_for_roof_desc",
				progress_bar = true,
				music_wwise_state = "fortification_event",
				header = "loc_objective_fm_armoury_wait_for_roof_header",
				event_type = "end_event",
				duration = 200,
				mission_objective_type = "timed"
			},
			objective_fm_armoury_activate_beacon = {
				description = "loc_objective_fm_armoury_activate_beacon_desc",
				music_wwise_state = "fortification_event",
				header = "loc_objective_fm_armoury_activate_beacon_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_fm_armoury_survive_final = {
				description = "loc_objective_fm_armoury_survive_final_desc",
				progress_bar = true,
				music_wwise_state = "fortification_event",
				header = "loc_objective_fm_armoury_survive_final_header",
				event_type = "end_event",
				duration = 60,
				mission_objective_type = "timed"
			},
			objective_fm_armoury_clear_area = {
				description = "loc_objective_fm_armoury_clear_area_desc",
				music_wwise_state = "fortification_event",
				header = "loc_objective_fm_armoury_clear_area_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_fm_armoury_reach_valkyrie = {
				description = "loc_objective_fm_armoury_reach_valkyrie_desc",
				music_wwise_state = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_fm_armoury_reach_valkyrie_header"
			},
			objective_fm_armoury_luggable_secret = {
				mission_objective_type = "luggable",
				hidden = true
			}
		}
	}
}

return mission_objective_templates
