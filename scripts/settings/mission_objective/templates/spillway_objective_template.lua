-- chunkname: @scripts/settings/mission_objective/templates/spillway_objective_template.lua

local mission_objective_templates = {
	spillway = {
		objectives = {
			objective_spillway_traversal_depths_chasm = {
				description = "loc_objective_spillway_traversal_depths_chasm_desc",
				header = "loc_objective_spillway_traversal_depths_chasm_header",
				mission_objective_type = "goal",
			},
			objective_spillway_traversal_dam = {
				description = "loc_objective_spillway_traversal_dam_desc",
				header = "loc_objective_spillway_traversal_dam_header",
				mission_objective_type = "goal",
			},
			objective_spillway_midevent_locate_symbol = {
				description = "loc_objective_spillway_midevent_locate_symbol_desc",
				header = "loc_objective_spillway_midevent_locate_symbol_header",
				mission_objective_type = "goal",
			},
			objective_spillway_midevent_eliminate_target = {
				description = "loc_objective_spillway_midevent_eliminate_target_desc",
				header = "loc_objective_spillway_midevent_eliminate_target_header",
				mission_objective_type = "kill",
				music_wwise_state = "kill_event",
			},
			objective_spillway_midevent_memorize_symbol = {
				description = "loc_objective_spillway_midevent_memorize_symbol_desc",
				header = "loc_objective_spillway_midevent_memorize_symbol_header",
				mission_objective_type = "goal",
			},
			objective_spillway_midevent_activate_bridge = {
				description = "loc_objective_spillway_midevent_activate_bridge_desc",
				header = "loc_objective_spillway_midevent_activate_bridge_header",
				mission_objective_type = "goal",
			},
			objective_spillway_sewer_labyrinth = {
				description = "loc_objective_spillway_sewer_labyrinth_desc",
				header = "loc_objective_spillway_sewer_labyrinth_header",
				mission_objective_type = "goal",
			},
			objective_spillway_decoder_trap_a = {
				description = "loc_objective_spillway_decoder_desc",
				header = "loc_objective_spillway_decoder_header",
				mission_objective_type = "decode",
				progress_bar = true,
			},
			objective_spillway_decoder_trap_b = {
				description = "loc_objective_spillway_decoder_desc",
				header = "loc_objective_spillway_decoder_header",
				mission_objective_type = "decode",
				progress_bar = true,
			},
			objective_spillway_second_decoder_trap_a = {
				description = "loc_objective_spillway_decoder_desc",
				header = "loc_objective_spillway_decoder_header",
				mission_objective_type = "decode",
				progress_bar = true,
			},
			objective_spillway_second_decoder_trap_a_02 = {
				description = "loc_objective_spillway_decoder_desc",
				header = "loc_objective_spillway_decoder_header",
				mission_objective_type = "decode",
				progress_bar = true,
			},
			objective_spillway_second_decoder_trap_a_03 = {
				description = "loc_objective_spillway_decoder_desc",
				header = "loc_objective_spillway_decoder_header",
				mission_objective_type = "decode",
				progress_bar = true,
			},
			objective_spillway_demolition_trap_01 = {
				description = "loc_objective_spillway_demolition_trap_desc",
				header = "loc_objective_spillway_demolition_trap_header",
				mission_objective_type = "demolition",
			},
			objective_spillway_demolition_trap_02 = {
				description = "loc_objective_spillway_demolition_trap_desc",
				header = "loc_objective_spillway_demolition_trap_header",
				mission_objective_type = "demolition",
			},
			objective_spillway_demolition_trap_03 = {
				description = "loc_objective_spillway_demolition_trap_desc",
				header = "loc_objective_spillway_demolition_trap_header",
				mission_objective_type = "demolition",
			},
			objective_spillway_locate_lair = {
				description = "loc_objective_spillway_locate_lair_desc",
				header = "loc_objective_spillway_locate_lair_header",
				mission_objective_type = "goal",
				turn_off_backfill = true,
			},
			objective_spillway_endevent_eliminate_psyker_boss = {
				description = "loc_objective_spillway_endevent_eliminate_psyker_boss_desc",
				header = "loc_objective_spillway_endevent_eliminate_psyker_boss_header",
				mission_objective_type = "goal",
			},
			objective_spillway_endevent_boss_music = {
				description = "loc_objective_spillway_endevent_eliminate_psyker_boss_desc",
				event_type = "end_event",
				header = "loc_objective_spillway_endevent_eliminate_psyker_boss_header",
				hidden = true,
				mission_objective_type = "goal",
				music_ignore_start_event = true,
				music_wwise_state = "kill_event_3",
				popups_enabled = false,
			},
		},
	},
}

return mission_objective_templates
