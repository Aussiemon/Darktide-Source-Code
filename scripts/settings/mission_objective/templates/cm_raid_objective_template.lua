local mission_objective_templates = {
	cm_raid = {
		main_objective_type = "control_objective",
		objectives = {
			objective_cm_raid_start = {
				description = "loc_objective_cm_raid_start_desc",
				mission_objective_type = "goal",
				header = "loc_objective_cm_raid_start_header"
			},
			objective_cm_raid_find_obscura_den = {
				description = "loc_objective_cm_raid_find_obscura_den_desc",
				mission_objective_type = "goal",
				header = "loc_objective_cm_raid_find_obscura_den_header"
			},
			objective_cm_raid_obscura_survive = {
				description = "loc_objective_cm_raid_obscura_survive_desc",
				progress_bar = true,
				use_music_event = "gauntlet_event",
				header = "loc_objective_cm_raid_obscura_survive_header",
				event_type = "mid_event",
				duration = 60,
				mission_objective_type = "timed"
			},
			objective_cm_raid_obscura_breaching_charge = {
				description = "loc_objective_cm_raid_obscura_breaching_charge_desc",
				use_music_event = "gauntlet_event",
				mission_objective_type = "goal",
				header = "loc_objective_cm_raid_obscura_breaching_charge_header"
			},
			objective_cm_raid_obscura_progress_cellar = {
				description = "loc_objective_cm_raid_obscura_progress_cellar_desc",
				use_music_event = "gauntlet_event",
				mission_objective_type = "goal",
				header = "loc_objective_cm_raid_obscura_progress_cellar_header"
			},
			objective_cm_raid_obscura_den_decode_stage_two = {
				description = "loc_objective_cm_raid_obscura_den_decode_desc",
				use_music_event = "gauntlet_event",
				header = "loc_objective_cm_raid_obscura_den_decode_header",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_cm_raid_obscura_exit = {
				description = "loc_objective_cm_raid_obscura_exit_desc",
				mission_objective_type = "goal",
				header = "loc_objective_cm_raid_obscura_exit_header"
			},
			objective_cm_raid_find_drug_lab = {
				description = "loc_objective_cm_raid_find_drug_lab_desc",
				mission_objective_type = "goal",
				header = "loc_objective_cm_raid_find_drug_lab_header"
			},
			objective_cm_raid_control_drug_lab = {
				description = "loc_objective_cm_raid_drug_lab_desc",
				has_second_progression = true,
				use_music_event = "progression_stage_1",
				header = "loc_objective_cm_raid_drug_lab_header",
				event_type = "end_event",
				progress_bar = true,
				mission_objective_type = "scanning",
				turn_off_backfill = true
			},
			objective_cm_raid_destroy_filtration_tanks = {
				description = "loc_objective_cm_raid_destroy_filtration_tanks_desc",
				use_music_event = "progression_stage_2",
				header = "loc_objective_cm_raid_destroy_filtration_tanks_header",
				turn_off_backfill = true,
				mission_objective_type = "goal"
			},
			objective_cm_raid_progress_second_floor = {
				description = "loc_objective_cm_raid_progress_second_floor_desc",
				use_music_event = "progression_stage_1",
				mission_objective_type = "goal",
				header = "loc_objective_cm_raid_progress_second_floor_header"
			},
			objective_cm_raid_progress_third_floor = {
				description = "loc_objective_cm_raid_progress_third_floor_desc",
				use_music_event = "progression_stage_2",
				mission_objective_type = "goal",
				header = "loc_objective_cm_raid_progress_third_floor_header"
			},
			objective_cm_raid_decode_refraction_field = {
				description = "loc_objective_cm_raid_decode_refraction_field_desc",
				use_music_event = "progression_stage_3",
				header = "loc_objective_cm_raid_decode_refraction_field_header",
				event_type = "end_event",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_cm_raid_filtration_tank_final_destruction = {
				description = "loc_objective_cm_raid_filtration_tank_final_destruction_desc",
				use_music_event = "progression_stage_4",
				mission_objective_type = "goal",
				header = "loc_objective_cm_raid_filtration_tank_final_destruction_header"
			},
			objective_cm_raid_escape = {
				description = "loc_objective_cm_raid_escape_desc",
				use_music_event = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_cm_raid_escape_header"
			}
		}
	}
}

return mission_objective_templates
