-- chunkname: @scripts/settings/mission_objective/templates/cm_raid_objective_template.lua

local mission_objective_templates = {
	cm_raid = {
		objectives = {
			objective_cm_raid_start = {
				description = "loc_objective_cm_raid_start_desc",
				header = "loc_objective_cm_raid_start_header",
				mission_objective_type = "goal",
			},
			objective_cm_raid_find_obscura_den = {
				description = "loc_objective_cm_raid_find_obscura_den_desc",
				header = "loc_objective_cm_raid_find_obscura_den_header",
				mission_objective_type = "goal",
			},
			objective_cm_raid_obscura_survive = {
				description = "loc_objective_cm_raid_obscura_survive_desc",
				duration = 60,
				event_type = "mid_event",
				header = "loc_objective_cm_raid_obscura_survive_header",
				mission_objective_type = "timed",
				music_wwise_state = "gauntlet_event",
				progress_bar = true,
			},
			objective_cm_raid_obscura_breaching_charge = {
				description = "loc_objective_cm_raid_obscura_breaching_charge_desc",
				header = "loc_objective_cm_raid_obscura_breaching_charge_header",
				mission_objective_type = "goal",
				music_wwise_state = "gauntlet_event",
			},
			objective_cm_raid_obscura_progress_cellar = {
				description = "loc_objective_cm_raid_obscura_progress_cellar_desc",
				header = "loc_objective_cm_raid_obscura_progress_cellar_header",
				mission_objective_type = "goal",
				music_wwise_state = "gauntlet_event",
			},
			objective_cm_raid_obscura_den_decode_stage_two = {
				description = "loc_objective_cm_raid_obscura_den_decode_desc",
				header = "loc_objective_cm_raid_obscura_den_decode_header",
				mission_objective_type = "decode",
				music_wwise_state = "gauntlet_event",
				progress_bar = true,
			},
			objective_cm_raid_obscura_exit = {
				description = "loc_objective_cm_raid_obscura_exit_desc",
				header = "loc_objective_cm_raid_obscura_exit_header",
				mission_objective_type = "goal",
			},
			objective_cm_raid_find_drug_lab = {
				description = "loc_objective_cm_raid_find_drug_lab_desc",
				header = "loc_objective_cm_raid_find_drug_lab_header",
				mission_objective_type = "goal",
			},
			objective_cm_raid_control_drug_lab = {
				description = "loc_objective_cm_raid_drug_lab_desc",
				event_type = "end_event",
				header = "loc_objective_cm_raid_drug_lab_header",
				mission_objective_type = "scanning",
				music_wwise_state = "progression_stage_1",
				progress_bar = true,
				turn_off_backfill = true,
			},
			objective_cm_raid_destroy_filtration_tanks = {
				description = "loc_objective_cm_raid_destroy_filtration_tanks_desc",
				header = "loc_objective_cm_raid_destroy_filtration_tanks_header",
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_2",
				turn_off_backfill = true,
			},
			objective_cm_raid_progress_second_floor = {
				description = "loc_objective_cm_raid_progress_second_floor_desc",
				header = "loc_objective_cm_raid_progress_second_floor_header",
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_1",
			},
			objective_cm_raid_progress_third_floor = {
				description = "loc_objective_cm_raid_progress_third_floor_desc",
				header = "loc_objective_cm_raid_progress_third_floor_header",
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_2",
			},
			objective_cm_raid_decode_refraction_field = {
				description = "loc_objective_cm_raid_decode_refraction_field_desc",
				event_type = "end_event",
				header = "loc_objective_cm_raid_decode_refraction_field_header",
				mission_objective_type = "decode",
				music_wwise_state = "progression_stage_3",
				progress_bar = true,
			},
			objective_cm_raid_filtration_tank_final_destruction = {
				description = "loc_objective_cm_raid_filtration_tank_final_destruction_desc",
				header = "loc_objective_cm_raid_filtration_tank_final_destruction_header",
				mission_objective_type = "goal",
				music_wwise_state = "progression_stage_4",
			},
			objective_cm_raid_escape = {
				description = "loc_objective_cm_raid_escape_desc",
				header = "loc_objective_cm_raid_escape_header",
				mission_objective_type = "goal",
				music_wwise_state = "escape_event",
			},
			objective_cm_raid_penance_breaching_charge = {
				hidden = true,
				mission_objective_type = "goal",
			},
		},
	},
}

return mission_objective_templates
