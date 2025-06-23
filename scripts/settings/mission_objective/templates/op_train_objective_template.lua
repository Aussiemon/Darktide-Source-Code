-- chunkname: @scripts/settings/mission_objective/templates/op_train_objective_template.lua

local mission_objective_templates = {
	op_train = {
		objectives = {
			objective_flash_train_reach_locomotive = {
				description = "loc_objective_op_train_timer_desc",
				music_wwise_state = "operation_stage_1",
				header = "loc_objective_op_train_timer_header",
				progression_sync_granularity = 0.001,
				mission_objective_type = "timed",
				progress_bar_icon = "content/ui/materials/icons/objectives/secondary",
				objective_category = "overarching",
				event_type = "end_event",
				progress_bar = true,
				duration_by_difficulty = {
					825,
					770,
					660,
					583,
					550
				}
			},
			objective_flash_train_alert = {
				description = "loc_objective_op_train_alert_header",
				music_wwise_state = "operation_stage_3",
				ui_state = "alert",
				header = "loc_objective_op_train_alert_desc",
				turn_off_backfill = true,
				mission_objective_type = "timed",
				objective_category = "overarching",
				progress_timer = true,
				duration = 30
			},
			objective_flash_train_defuse_bomb_one = {
				description = "loc_objective_op_train_defuse_one_desc",
				music_wwise_state = "operation_stage_1",
				progression_sync_granularity = 0.001,
				header = "loc_objective_op_train_defuse_one_header",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_flash_train_defuse_bomb_two = {
				description = "loc_objective_op_train_defuse_two_desc",
				music_wwise_state = "operation_stage_2",
				progression_sync_granularity = 0.001,
				header = "loc_objective_op_train_defuse_two_header",
				turn_off_backfill = true,
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_op_train_luggable_one = {
				description = "loc_objective_op_train_luggable_one_desc",
				music_wwise_state = "operation_stage_2",
				mission_objective_type = "luggable",
				header = "loc_objective_op_train_luggable_one_header"
			},
			objective_op_train_activate_mechanism = {
				description = "loc_objective_op_train_activate_mechanism_desc",
				music_wwise_state = "operation_stage_2",
				mission_objective_type = "goal",
				header = "loc_objective_op_train_activate_mechanism_header"
			},
			objective_flash_train_defuse_bomb_three = {
				description = "loc_objective_op_train_defuse_final_desc",
				music_wwise_state = "operation_stage_2",
				progression_sync_granularity = 0.001,
				header = "loc_objective_op_train_defuse_final_header",
				progress_bar = true,
				mission_objective_type = "decode"
			},
			objective_flash_train_defuse_bomb_four = {
				description = "loc_objective_op_train_defuse_final_desc",
				music_wwise_state = "operation_stage_2",
				header = "loc_objective_op_train_defuse_final_header",
				progression_sync_granularity = 0.001,
				mission_objective_type = "decode",
				hide_widget = true
			},
			objective_flash_train_defuse_final_bombs = {
				description = "loc_objective_op_train_defuse_final_desc",
				music_wwise_state = "operation_stage_2",
				mission_objective_type = "goal",
				header = "loc_objective_op_train_defuse_final_header"
			},
			objective_flash_train_eliminate_target = {
				description = "loc_objective_op_train_kill_captain_desc",
				music_wwise_state = "operation_stage_3",
				mission_objective_type = "kill",
				header = "loc_objective_op_train_kill_captain_header"
			},
			objective_flash_train_stop_train = {
				description = "loc_objective_op_stop_train_desc",
				music_wwise_state = "operation_stage_4",
				mission_objective_type = "goal",
				header = "loc_objective_op_stop_train_header"
			},
			objective_flash_train_extract = {
				description = "loc_objective_op_extract_desc",
				music_wwise_state = "escape_event",
				mission_objective_type = "goal",
				header = "loc_objective_op_extract_header"
			}
		}
	}
}

return mission_objective_templates
