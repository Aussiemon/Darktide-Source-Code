-- chunkname: @scripts/settings/mission_objective/templates/km_heresy_objective_template.lua

local mission_objective_templates = {
	km_heresy = {
		objectives = {
			objective_km_heresy_survive_mid = {
				description = "loc_objective_km_heresy_survive_mid_desc",
				music_wwise_state = "fortification_event",
				header = "loc_objective_km_heresy_survive_mid_header",
				event_type = "mid_event",
				mission_objective_type = "goal"
			},
			objective_km_heresy_luggable = {
				description = "luggable objective description",
				music_wwise_state = "control_mission",
				mission_objective_type = "luggable",
				header = "luggable objective header"
			},
			objective_km_heresy_clear = {
				description = "loc_objective_km_heresy_clear_desc",
				music_wwise_state = "fortification_event",
				mission_objective_type = "goal",
				header = "loc_objective_km_heresy_clear_header"
			},
			objective_km_heresy_kill_monster = {
				description = "loc_objective_km_heresy_kill_monster_desc",
				music_wwise_state = "fortification_event",
				header = "loc_objective_km_heresy_kill_monster_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_km_heresy_bridge_music_start = {
				description = "loc_objective_km_heresy_kill_summoners_desc",
				music_wwise_state = "progression2_stage_1",
				popups_enabled = false,
				header = "loc_objective_km_heresy_kill_summoners_header",
				event_type = "end_event",
				hidden = true,
				mission_objective_type = "goal"
			},
			objective_km_heresy_kill_summoners = {
				description = "loc_objective_km_heresy_kill_summoners_desc",
				music_wwise_priority = 1,
				music_wwise_state = "progression2_stage_2",
				header = "loc_objective_km_heresy_kill_summoners_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_km_heresy_kill_summoners_part2 = {
				description = "loc_objective_km_heresy_kill_summoners_desc",
				music_wwise_priority = 1,
				popups_enabled = false,
				header = "loc_objective_km_heresy_kill_summoners_header",
				event_type = "end_event",
				hidden = true,
				mission_objective_type = "goal",
				music_wwise_state = "progression2_stage_2"
			},
			objective_km_heresy_kill_summoners_part3 = {
				description = "loc_objective_km_heresy_kill_summoners_desc",
				music_wwise_priority = 2,
				popups_enabled = false,
				header = "loc_objective_km_heresy_kill_summoners_header",
				event_type = "end_event",
				hidden = true,
				mission_objective_type = "goal",
				music_wwise_state = "progression2_stage_3"
			},
			objective_km_heresy_disrupt_ritual = {
				description = "loc_objective_km_heresy_disrupt_ritual_desc",
				music_wwise_state = "progression2_stage_4",
				header = "loc_objective_km_heresy_disrupt_ritual_header",
				event_type = "end_event",
				mission_objective_type = "goal"
			},
			objective_km_heresy_eliminate_target = {
				description = "loc_objective_km_heresy_eliminate_target_desc",
				music_wwise_state = "kill_event",
				header = "loc_objective_km_heresy_eliminate_target_header",
				event_type = "end_event",
				mission_objective_type = "kill"
			}
		}
	}
}

return mission_objective_templates
