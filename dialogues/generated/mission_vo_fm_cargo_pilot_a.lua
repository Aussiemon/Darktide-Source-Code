-- chunkname: @dialogues/generated/mission_vo_fm_cargo_pilot_a.lua

local mission_vo_fm_cargo_pilot_a = {
	mission_cargo_reinforcements_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_pilot_a__cmd_mission_completed_response_01",
			"loc_pilot_a__cmd_mission_completed_response_02",
			"loc_pilot_a__cmd_mission_completed_response_03",
			"loc_pilot_a__cmd_mission_completed_response_04",
			"loc_pilot_a__cmd_mission_completed_response_05"
		},
		sound_events_duration = {
			3.689583,
			4.107542,
			2.011313,
			2.550854,
			3.072167
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_fm_cargo_pilot_a", mission_vo_fm_cargo_pilot_a)
