-- chunkname: @scripts/settings/mission_objective/templates/dm_forge_objective_template.lua

local mission_objective_templates = {
	dm_forge = {
		main_objective_type = "demolition_objective",
		objectives = {
			objective_dm_forge_leave_start = {
				description = "loc_objective_dm_forge_leave_start_desc",
				header = "loc_objective_dm_forge_leave_start_header",
				mission_objective_type = "goal",
			},
			objective_dm_forge_find_furnace_entrance = {
				description = "loc_objective_dm_forge_find_furnace_entrance_desc",
				header = "loc_objective_dm_forge_find_furnace_entrance_header",
				mission_objective_type = "goal",
			},
			objective_dm_forge_call_elevator = {
				description = "loc_objective_dm_forge_call_elevator_desc",
				header = "loc_objective_dm_forge_call_elevator_header",
				mission_objective_type = "goal",
			},
			objective_dm_forge_wait_for_elevator = {
				description = "loc_objective_dm_forge_wait_for_elevator_desc",
				duration = 90,
				event_type = "mid_event",
				header = "loc_objective_dm_forge_wait_for_elevator_header",
				mission_objective_type = "timed",
				progress_bar = false,
				use_music_event = "fortification_event",
			},
			objective_dm_forge_ride_elevator = {
				description = "loc_objective_dm_forge_ride_elevator_desc",
				header = "loc_objective_dm_forge_ride_elevator_header",
				mission_objective_type = "goal",
			},
			objective_dm_forge_purge_daemonic_growth = {
				description = "loc_objective_dm_forge_purge_daemonic_growth_desc",
				header = "loc_objective_dm_forge_purge_daemonic_growth_header",
				mission_objective_type = "demolition",
				show_progression_popup_on_update = false,
			},
			objective_dm_forge_restart_furnace_machinery = {
				description = "loc_objective_dm_forge_restart_furnace_machinery_desc",
				header = "loc_objective_dm_forge_restart_furnace_machinery_header",
				mission_objective_type = "goal",
			},
			objective_dm_forge_find_forge = {
				description = "loc_objective_dm_forge_find_forge_desc",
				header = "loc_objective_dm_forge_find_forge_header",
				mission_objective_type = "goal",
			},
			objective_dm_forge_find_foundry = {
				description = "loc_objective_dm_forge_find_foundry_desc",
				header = "loc_objective_dm_forge_find_foundry_header",
				mission_objective_type = "goal",
			},
			objective_dm_forge_activate_smelter = {
				description = "loc_objective_dm_forge_activate_smelter_desc",
				header = "loc_objective_dm_forge_activate_smelter_header",
				mission_objective_type = "goal",
				music_ignore_start_event = true,
				turn_off_backfill = true,
				use_music_event = "demolition_event",
			},
			objective_dm_forge_destroy_corruptor_one = {
				description = "loc_objective_dm_forge_destroy_corruptor_one_desc",
				event_type = "end_event",
				header = "loc_objective_dm_forge_destroy_corruptor_one_header",
				mission_objective_type = "demolition",
				show_progression_popup_on_update = false,
				use_music_event = "demolition_event",
			},
			objective_dm_forge_survive = {
				description = "loc_objective_dm_forge_survive_desc",
				event_type = "end_event",
				header = "loc_objective_dm_forge_survive_header",
				mission_objective_type = "goal",
				use_music_event = "demolition_event",
			},
			objective_dm_forge_reactivate_smelter = {
				description = "loc_objective_dm_forge_reactivate_smelter_desc",
				event_type = "end_event",
				header = "loc_objective_dm_forge_reactivate_smelter_header",
				mission_objective_type = "goal",
				music_ignore_start_event = true,
				use_music_event = "demolition_event",
			},
			objective_dm_forge_hold_position = {
				description = "loc_objective_dm_forge_hold_position_desc",
				duration = 20,
				event_type = "end_event",
				header = "loc_objective_dm_forge_hold_position_header",
				mission_objective_type = "timed",
				progress_bar = false,
				use_music_event = "demolition_event",
			},
			objective_dm_forge_clear = {
				description = "loc_objective_dm_forge_clear_desc",
				event_type = "end_event",
				header = "loc_objective_dm_forge_clear_header",
				mission_objective_type = "goal",
				use_music_event = "demolition_event",
			},
			objective_dm_forge_extract = {
				description = "loc_objective_dm_forge_extract_desc",
				header = "loc_objective_dm_forge_extract_header",
				mission_objective_type = "goal",
				use_music_event = "escape_event",
			},
		},
	},
}

return mission_objective_templates
