-- chunkname: @dialogues/generated/mission_giver_vo_training_ground_psyker_a.lua

local mission_giver_vo_training_ground_psyker_a = {
	cmd_deploy_skull = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_training_ground_psyker_a__cmd_deploy_skull_01",
			"loc_training_ground_psyker_a__cmd_deploy_skull_02",
			"loc_training_ground_psyker_a__cmd_deploy_skull_03",
			"loc_training_ground_psyker_a__cmd_deploy_skull_04",
		},
		sound_events_duration = {
			6.286271,
			7.784271,
			6.883938,
			7.580271,
		},
		randomize_indexes = {},
	},
	info_event_one_down = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_training_ground_psyker_a__tg_success_01",
			"loc_training_ground_psyker_a__tg_success_03",
			"loc_training_ground_psyker_a__tg_success_04",
		},
		sound_events_duration = {
			2.870979,
			3.254625,
			4.6355,
		},
		randomize_indexes = {},
	},
}

return settings("mission_giver_vo_training_ground_psyker_a", mission_giver_vo_training_ground_psyker_a)
