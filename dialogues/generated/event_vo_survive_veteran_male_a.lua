-- chunkname: @dialogues/generated/event_vo_survive_veteran_male_a.lua

local event_vo_survive_veteran_male_a = {
	event_survive_almost_done = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_a__event_survive_almost_done_01",
			"loc_veteran_male_a__event_survive_almost_done_02",
			"loc_veteran_male_a__event_survive_almost_done_03",
			"loc_veteran_male_a__event_survive_almost_done_04"
		},
		sound_events_duration = {
			1.258396,
			2.39925,
			0.9765,
			3.218917
		},
		randomize_indexes = {}
	},
	event_survive_keep_coming_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_a__event_survive_keep_coming_a_01",
			"loc_veteran_male_a__event_survive_keep_coming_a_02",
			"loc_veteran_male_a__event_survive_keep_coming_a_03",
			"loc_veteran_male_a__event_survive_keep_coming_a_04"
		},
		sound_events_duration = {
			2.301333,
			2.426542,
			2.969542,
			2.517521
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_survive_veteran_male_a", event_vo_survive_veteran_male_a)
