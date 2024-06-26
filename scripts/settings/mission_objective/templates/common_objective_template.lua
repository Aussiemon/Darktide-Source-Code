-- chunkname: @scripts/settings/mission_objective/templates/common_objective_template.lua

local mission_objective_templates = {
	common = {
		objectives = {
			default = {
				description = "loc_objective_common_default_desc",
				header = "loc_objective_common_default_header",
				mission_objective_type = "goal",
				music_wwise_state = "None",
			},
			objective_test = {
				description = "loc_objective_common_default_desc",
				header = "loc_objective_common_default_header",
				mission_objective_type = "goal",
				music_wwise_state = "None",
			},
			timed_test = {
				description = "loc_objective_common_timed_test_desc",
				duration = 60,
				header = "loc_objective_common_timed_test_header",
				mission_objective_type = "timed",
				music_wwise_state = "last_stand",
				progress_bar = true,
			},
			demolition_objective = {
				description = "loc_objective_common_demolition_desc",
				header = "loc_objective_common_demolition_header",
				mission_objective_type = "demolition",
				music_wwise_state = "purge_mission",
			},
			decoding_objective = {
				description = "loc_objective_common_decoding_desc",
				header = "loc_objective_common_decoding_header",
				mission_objective_type = "decode",
				music_wwise_state = "control_mission",
				progress_bar = true,
			},
			control_objective = {
				collect_amount = 3,
				description = "loc_objective_common_control_desc",
				header = "loc_objective_common_control_header",
				mission_objective_type = "collect",
				music_wwise_state = "control_mission",
			},
			captain_kill_target = {
				description = "loc_objective_common_captain_kill_desc",
				header = "loc_objective_common_captain_kill_header",
				mission_objective_type = "kill",
				music_wwise_state = "kill_mission",
			},
			luggable_objective = {
				description = "loc_objective_common_luggable_desc",
				header = "loc_objective_common_luggable_header",
				mission_objective_type = "luggable",
				music_wwise_state = "control_mission",
			},
			objective_twins_ambush = {
				description = "loc_objective_km_enforcer_eliminate_target_desc",
				event_type = "mid_event",
				header = "loc_objective_km_enforcer_eliminate_target_header",
				hidden = true,
				mission_objective_type = "goal",
				music_wwise_state = "twins_event",
			},
		},
	},
}

return mission_objective_templates
