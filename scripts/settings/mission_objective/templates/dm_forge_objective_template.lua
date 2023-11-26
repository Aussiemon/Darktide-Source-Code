-- chunkname: @scripts/settings/mission_objective/templates/dm_forge_objective_template.lua

local mission_objective_templates = {
	dm_forge = {
		main_objective_type = "demolition_objective",
		objectives = {
			objective_dm_forge_leave_start = {
				description = "loc_objective_dm_forge_leave_start_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_forge_leave_start_header"
			},
			objective_dm_forge_find_furnace_entrance = {
				description = "loc_objective_dm_forge_find_furnace_entrance_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_forge_find_furnace_entrance_header"
			},
			objective_dm_forge_call_elevator = {
				description = "loc_objective_dm_forge_call_elevator_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_forge_call_elevator_header"
			},
			objective_dm_forge_wait_for_elevator = {
				use_music_event = "fortification_event",
				description = "loc_objective_dm_forge_wait_for_elevator_desc",
				progress_bar = false,
				header = "loc_objective_dm_forge_wait_for_elevator_header",
				event_type = "mid_event",
				duration = 90,
				mission_objective_type = "timed"
			},
			objective_dm_forge_ride_elevator = {
				description = "loc_objective_dm_forge_ride_elevator_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_forge_ride_elevator_header"
			},
			objective_dm_forge_purge_daemonic_growth = {
				description = "loc_objective_dm_forge_purge_daemonic_growth_desc",
				show_progression_popup_on_update = false,
				mission_objective_type = "demolition",
				header = "loc_objective_dm_forge_purge_daemonic_growth_header"
			},
			objective_dm_forge_restart_furnace_machinery = {
				description = "loc_objective_dm_forge_restart_furnace_machinery_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_forge_restart_furnace_machinery_header"
			},
			objective_dm_forge_find_forge = {
				description = "loc_objective_dm_forge_find_forge_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_forge_find_forge_header"
			},
			objective_dm_forge_find_foundry = {
				description = "loc_objective_dm_forge_find_foundry_desc",
				mission_objective_type = "goal",
				header = "loc_objective_dm_forge_find_foundry_header"
			},
			objective_dm_forge_activate_smelter = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_forge_activate_smelter_desc",
				header = "loc_objective_dm_forge_activate_smelter_header",
				turn_off_backfill = true,
				mission_objective_type = "goal",
				music_ignore_start_event = true
			},
			objective_dm_forge_destroy_corruptor_one = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_forge_destroy_corruptor_one_desc",
				show_progression_popup_on_update = false,
				header = "loc_objective_dm_forge_destroy_corruptor_one_header",
				event_type = "end_event",
				mission_objective_type = "demolition"
			},
			objective_dm_forge_survive = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_forge_survive_desc",
				header = "loc_objective_dm_forge_survive_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_dm_forge_reactivate_smelter = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_forge_reactivate_smelter_desc",
				header = "loc_objective_dm_forge_reactivate_smelter_header",
				event_type = "end_event",
				mission_objective_type = "goal",
				music_ignore_start_event = true
			},
			objective_dm_forge_hold_position = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_forge_hold_position_desc",
				progress_bar = false,
				header = "loc_objective_dm_forge_hold_position_header",
				event_type = "end_event",
				duration = 20,
				mission_objective_type = "timed"
			},
			objective_dm_forge_clear = {
				use_music_event = "demolition_event",
				description = "loc_objective_dm_forge_clear_desc",
				header = "loc_objective_dm_forge_clear_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_dm_forge_extract = {
				description = "loc_objective_dm_forge_extract_desc",
				use_music_event = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_dm_forge_extract_header"
			}
		}
	}
}

return mission_objective_templates
