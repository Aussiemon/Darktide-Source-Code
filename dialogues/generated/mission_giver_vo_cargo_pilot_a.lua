-- chunkname: @dialogues/generated/mission_giver_vo_cargo_pilot_a.lua

local mission_giver_vo_cargo_pilot_a = {
	mission_agnostic_dropship_withdraw_a = {
		randomize_indexes_n = 0,
		sound_events_n = 6,
		sound_events = {
			"loc_cargo_pilot_a__mission_agnostic_dropship_withdraw_a_01",
			"loc_cargo_pilot_a__mission_agnostic_dropship_withdraw_a_02",
			"loc_cargo_pilot_a__mission_agnostic_dropship_withdraw_a_03",
			"loc_cargo_pilot_a__mission_agnostic_dropship_withdraw_a_04",
			"loc_cargo_pilot_a__mission_agnostic_dropship_withdraw_a_05",
			"loc_cargo_pilot_a__mission_agnostic_dropship_withdraw_a_06",
		},
		sound_events_duration = {
			3.065792,
			2.958729,
			3.282292,
			3.628479,
			3.257354,
			3.239563,
		},
		randomize_indexes = {},
	},
}

return settings("mission_giver_vo_cargo_pilot_a", mission_giver_vo_cargo_pilot_a)
