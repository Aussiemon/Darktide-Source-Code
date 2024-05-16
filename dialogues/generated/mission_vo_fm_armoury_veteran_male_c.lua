-- chunkname: @dialogues/generated/mission_vo_fm_armoury_veteran_male_c.lua

local mission_vo_fm_armoury_veteran_male_c = {
	mission_armoury_side_streets_c_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_male_c__region_carnival_a_01",
			"loc_veteran_male_c__region_carnival_a_02",
			"loc_veteran_male_c__region_carnival_a_03",
		},
		sound_events_duration = {
			2.745875,
			3.548396,
			2.286521,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_fm_armoury_veteran_male_c", mission_vo_fm_armoury_veteran_male_c)
