-- chunkname: @scripts/settings/mission_objective/templates/op_train_objective_template.lua

local mission_objective_templates = {
	op_train = {
		objectives = {
			objective_flash_train_reach_locomotive = {
				description = "loc_objective_op_train_timer_desc",
				event_type = "end_event",
				header = "loc_objective_op_train_timer_header",
				mission_objective_type = "timed",
				music_wwise_state = "operation_stage_1",
				objective_category = "overarching",
				progress_bar = true,
				progress_bar_icon = "content/ui/materials/icons/objectives/secondary",
				progression_sync_granularity = 0.001,
				duration_by_difficulty = {
					750,
					700,
					600,
					530,
					500,
				},
			},
			objective_flash_train_alert = {
				description = "loc_objective_op_train_alert_header",
				duration = 30,
				header = "loc_objective_op_train_alert_desc",
				mission_objective_type = "timed",
				music_wwise_state = "operation_stage_3",
				objective_category = "overarching",
				progress_timer = true,
				ui_state = "alert",
			},
			objective_flash_train_defuse_bomb_one = {
				description = "loc_objective_op_train_defuse_one_desc",
				header = "loc_objective_op_train_defuse_one_header",
				mission_objective_type = "decode",
				music_wwise_state = "operation_stage_1",
				progress_bar = true,
			},
			objective_flash_train_defuse_bomb_two = {
				description = "loc_objective_op_train_defuse_two_desc",
				header = "loc_objective_op_train_defuse_two_header",
				mission_objective_type = "decode",
				music_wwise_state = "operation_stage_2",
				progress_bar = true,
			},
			objective_op_train_luggable_one = {
				description = "loc_objective_op_train_luggable_one_desc",
				header = "loc_objective_op_train_luggable_one_header",
				mission_objective_type = "luggable",
				music_wwise_state = "operation_stage_2",
			},
			objective_op_train_activate_mechanism = {
				description = "loc_objective_op_train_activate_mechanism_desc",
				header = "loc_objective_op_train_activate_mechanism_header",
				mission_objective_type = "goal",
				music_wwise_state = "operation_stage_2",
			},
			objective_flash_train_defuse_bomb_three = {
				description = "loc_objective_op_train_defuse_final_desc",
				header = "loc_objective_op_train_defuse_final_header",
				mission_objective_type = "decode",
				music_wwise_state = "operation_stage_2",
				progress_bar = true,
				turn_off_backfill = true,
			},
			objective_flash_train_defuse_bomb_four = {
				description = "loc_objective_op_train_defuse_final_desc",
				header = "loc_objective_op_train_defuse_final_header",
				hide_widget = true,
				mission_objective_type = "decode",
				music_wwise_state = "operation_stage_2",
			},
			objective_flash_train_defuse_final_bombs = {
				description = "loc_objective_op_train_defuse_final_desc",
				header = "loc_objective_op_train_defuse_final_header",
				mission_objective_type = "goal",
				music_wwise_state = "operation_stage_2",
			},
			objective_flash_train_eliminate_target = {
				description = "loc_objective_op_train_kill_captain_desc",
				header = "loc_objective_op_train_kill_captain_header",
				mission_objective_type = "kill",
				music_wwise_state = "operation_stage_3",
			},
			objective_flash_train_stop_train = {
				description = "loc_objective_op_stop_train_desc",
				header = "loc_objective_op_stop_train_header",
				mission_objective_type = "goal",
				music_wwise_state = "operation_stage_4",
			},
			objective_flash_train_extract = {
				description = "loc_objective_op_extract_desc",
				header = "loc_objective_op_extract_header",
				mission_objective_type = "goal",
				music_wwise_state = "escape_event",
			},
		},
	},
}

return mission_objective_templates
