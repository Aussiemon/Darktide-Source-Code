-- chunkname: @scripts/settings/mission_objective/templates/common_objective_template.lua

local mission_objective_templates = {
	common = {
		objectives = {
			default = {
				description = "loc_objective_common_default_desc",
				header = "loc_objective_common_default_header",
				mission_objective_type = "goal",
				use_music_event = "None",
			},
			objective_test = {
				description = "loc_objective_common_default_desc",
				header = "loc_objective_common_default_header",
				mission_objective_type = "goal",
				use_music_event = "None",
			},
			timed_test = {
				description = "loc_objective_common_timed_test_desc",
				duration = 60,
				header = "loc_objective_common_timed_test_header",
				mission_objective_type = "timed",
				progress_bar = true,
				use_music_event = "last_stand",
			},
			demolition_objective = {
				description = "loc_objective_common_demolition_desc",
				header = "loc_objective_common_demolition_header",
				mission_objective_type = "demolition",
				use_music_event = "purge_mission",
			},
			decoding_objective = {
				description = "loc_objective_common_decoding_desc",
				header = "loc_objective_common_decoding_header",
				mission_objective_type = "decode",
				progress_bar = true,
				use_music_event = "control_mission",
			},
			control_objective = {
				collect_amount = 3,
				description = "loc_objective_common_control_desc",
				header = "loc_objective_common_control_header",
				mission_objective_type = "collect",
				use_music_event = "control_mission",
			},
			captain_kill_target = {
				description = "loc_objective_common_captain_kill_desc",
				header = "loc_objective_common_captain_kill_header",
				mission_objective_type = "kill",
				use_music_event = "kill_mission",
			},
			luggable_objective = {
				description = "loc_objective_common_luggable_desc",
				header = "loc_objective_common_luggable_header",
				mission_objective_type = "luggable",
				use_music_event = "control_mission",
			},
			objective_twins_ambush = {
				description = "loc_objective_km_enforcer_eliminate_target_desc",
				event_type = "mid_event",
				header = "loc_objective_km_enforcer_eliminate_target_header",
				hidden = true,
				mission_objective_type = "goal",
				use_music_event = "twins_event",
			},
		},
	},
}

return mission_objective_templates
