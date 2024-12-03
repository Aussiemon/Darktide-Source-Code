-- chunkname: @scripts/settings/mission_objective/templates/km_heresy_objective_template.lua

local mission_objective_templates = {
	km_heresy = {
		objectives = {
			objective_km_heresy_survive_mid = {
				description = "loc_objective_km_heresy_survive_mid_desc",
				event_type = "mid_event",
				header = "loc_objective_km_heresy_survive_mid_header",
				mission_objective_type = "goal",
				music_wwise_state = "fortification_event",
			},
			objective_km_heresy_luggable = {
				description = "luggable objective description",
				header = "luggable objective header",
				mission_objective_type = "luggable",
				music_wwise_state = "control_mission",
			},
			objective_km_heresy_clear = {
				description = "loc_objective_km_heresy_clear_desc",
				header = "loc_objective_km_heresy_clear_header",
				mission_objective_type = "goal",
				music_wwise_state = "fortification_event",
			},
			objective_km_heresy_kill_monster = {
				description = "loc_objective_km_heresy_kill_monster_desc",
				event_type = "end_event",
				header = "loc_objective_km_heresy_kill_monster_header",
				mission_objective_type = "goal",
				music_wwise_state = "fortification_event",
			},
			objective_km_heresy_bridge_music_start = {
				description = "loc_objective_km_heresy_kill_summoners_desc",
				event_type = "end_event",
				header = "loc_objective_km_heresy_kill_summoners_header",
				hidden = true,
				mission_objective_type = "goal",
				music_wwise_state = "progression2_stage_1",
				popups_enabled = false,
			},
			objective_km_heresy_kill_summoners = {
				description = "loc_objective_km_heresy_kill_summoners_desc",
				event_type = "end_event",
				header = "loc_objective_km_heresy_kill_summoners_header",
				mission_objective_type = "goal",
				music_wwise_priority = 1,
				music_wwise_state = "progression2_stage_2",
			},
			objective_km_heresy_kill_summoners_part2 = {
				description = "loc_objective_km_heresy_kill_summoners_desc",
				event_type = "end_event",
				header = "loc_objective_km_heresy_kill_summoners_header",
				hidden = true,
				mission_objective_type = "goal",
				music_wwise_priority = 1,
				music_wwise_state = "progression2_stage_2",
				popups_enabled = false,
			},
			objective_km_heresy_kill_summoners_part3 = {
				description = "loc_objective_km_heresy_kill_summoners_desc",
				event_type = "end_event",
				header = "loc_objective_km_heresy_kill_summoners_header",
				hidden = true,
				mission_objective_type = "goal",
				music_wwise_priority = 2,
				music_wwise_state = "progression2_stage_3",
				popups_enabled = false,
			},
			objective_km_heresy_disrupt_ritual = {
				description = "loc_objective_km_heresy_disrupt_ritual_desc",
				event_type = "end_event",
				header = "loc_objective_km_heresy_disrupt_ritual_header",
				mission_objective_type = "goal",
				music_wwise_state = "progression2_stage_4",
			},
			objective_km_heresy_eliminate_target = {
				description = "loc_objective_km_heresy_eliminate_target_desc",
				event_type = "end_event",
				header = "loc_objective_km_heresy_eliminate_target_header",
				mission_objective_type = "kill",
				music_wwise_state = "kill_event",
			},
		},
	},
}

return mission_objective_templates
