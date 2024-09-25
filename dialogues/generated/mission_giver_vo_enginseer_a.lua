-- chunkname: @dialogues/generated/mission_giver_vo_enginseer_a.lua

local mission_giver_vo_enginseer_a = {
	cmd_deploy_skull = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_enginseer_a__cmd_deploy_skull_01",
			"loc_enginseer_a__cmd_deploy_skull_02",
			"loc_enginseer_a__cmd_deploy_skull_03",
			"loc_enginseer_a__cmd_deploy_skull_04",
		},
		sound_events_duration = {
			7.55175,
			7.51174,
			6.978865,
			7.445405,
		},
		randomize_indexes = {},
	},
	mission_agnostic_dropship_deploy_a = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_enginseer_a__mission_agnostic_dropship_deploy_a_01",
			"loc_enginseer_a__mission_agnostic_dropship_deploy_a_02",
			"loc_enginseer_a__mission_agnostic_dropship_deploy_a_03",
		},
		sound_events_duration = {
			5.348521,
			5.124448,
			5.690332,
		},
		randomize_indexes = {},
	},
}

return settings("mission_giver_vo_enginseer_a", mission_giver_vo_enginseer_a)
