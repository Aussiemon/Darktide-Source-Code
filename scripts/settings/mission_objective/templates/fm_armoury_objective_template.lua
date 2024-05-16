-- chunkname: @scripts/settings/mission_objective/templates/fm_armoury_objective_template.lua

local mission_objective_templates = {
	fm_armoury = {
		main_objective_type = "fortification_objective",
		objectives = {
			objective_fm_armoury_gauntlet_start = {
				description = "loc_objective_fm_armoury_gauntlet_start_desc",
				event_type = "mid_event",
				header = "loc_objective_fm_armoury_gauntlet_start_header",
				mission_objective_type = "goal",
				use_music_event = "gauntlet_event",
			},
			objective_fm_armoury_gauntlet_secure_intel = {
				description = "loc_objective_fm_armoury_secure_intel_desc",
				duration = 80,
				event_type = "mid_event",
				header = "loc_objective_fm_armoury_secure_intel_header",
				mission_objective_type = "decode",
				progress_bar = true,
				use_music_event = "gauntlet_event",
			},
			objective_fm_armoury_confirm_intel = {
				description = "loc_objective_fm_armoury_confirm_intel_desc",
				event_type = "mid_event",
				header = "loc_objective_fm_armoury_confirm_intel_header",
				mission_objective_type = "goal",
				music_ignore_start_event = true,
				use_music_event = "gauntlet_event",
			},
			objective_fm_armoury_proceed = {
				description = "loc_objective_fm_armoury_proceed_desc",
				header = "loc_objective_fm_armoury_proceed_header",
				mission_objective_type = "goal",
			},
			objective_fm_armoury_brewery = {
				description = "loc_objective_fm_armoury_brewery_desc",
				header = "loc_objective_fm_armoury_brewery_header",
				mission_objective_type = "goal",
			},
			objective_fm_armoury_enter_black_market_area = {
				description = "loc_objective_fm_armoury_enter_black_market_area_header",
				header = "loc_objective_fm_armoury_enter_black_market_area_header",
				mission_objective_type = "goal",
			},
			objective_fm_armoury_find_stims = {
				description = "loc_objective_fm_armoury_find_stims_desc",
				header = "loc_objective_fm_armoury_find_stims_header",
				mission_objective_type = "goal",
				turn_off_backfill = true,
			},
			objective_fm_armoury_open_roof = {
				description = "loc_objective_fm_armoury_open_roof_desc",
				event_type = "end_event",
				header = "loc_objective_fm_armoury_open_roof_header",
				mission_objective_type = "goal",
				music_ignore_start_event = true,
				turn_off_backfill = true,
				use_music_event = "fortification_event",
			},
			objective_fm_armoury_wait_for_roof = {
				description = "loc_objective_fm_armoury_wait_for_roof_desc",
				duration = 200,
				event_type = "end_event",
				header = "loc_objective_fm_armoury_wait_for_roof_header",
				mission_objective_type = "timed",
				progress_bar = true,
				use_music_event = "fortification_event",
			},
			objective_fm_armoury_activate_beacon = {
				description = "loc_objective_fm_armoury_activate_beacon_desc",
				event_type = "end_event",
				header = "loc_objective_fm_armoury_activate_beacon_header",
				mission_objective_type = "goal",
				use_music_event = "fortification_event",
			},
			objective_fm_armoury_survive_final = {
				description = "loc_objective_fm_armoury_survive_final_desc",
				duration = 60,
				event_type = "end_event",
				header = "loc_objective_fm_armoury_survive_final_header",
				mission_objective_type = "timed",
				progress_bar = true,
				use_music_event = "fortification_event",
			},
			objective_fm_armoury_clear_area = {
				description = "loc_objective_fm_armoury_clear_area_desc",
				event_type = "end_event",
				header = "loc_objective_fm_armoury_clear_area_header",
				mission_objective_type = "goal",
				use_music_event = "fortification_event",
			},
			objective_fm_armoury_reach_valkyrie = {
				description = "loc_objective_fm_armoury_reach_valkyrie_desc",
				header = "loc_objective_fm_armoury_reach_valkyrie_header",
				mission_objective_type = "goal",
				use_music_event = "escape_event",
			},
			objective_fm_armoury_luggable_secret = {
				hidden = true,
				mission_objective_type = "luggable",
			},
		},
	},
}

return mission_objective_templates
