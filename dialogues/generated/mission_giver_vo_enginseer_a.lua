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
}

return settings("mission_giver_vo_enginseer_a", mission_giver_vo_enginseer_a)
