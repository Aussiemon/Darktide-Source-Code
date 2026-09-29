-- chunkname: @dialogues/generated/event_vo_survive_ogryn_a.lua

local event_vo_survive_ogryn_a = {
	event_survive_almost_done = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_a__event_survive_almost_done_01",
			"loc_ogryn_a__event_survive_almost_done_02",
			"loc_ogryn_a__event_survive_almost_done_03",
			"loc_ogryn_a__event_survive_almost_done_04"
		},
		sound_events_duration = {
			2.724875,
			1.463229,
			2.123083,
			3.45125
		},
		randomize_indexes = {}
	},
	event_survive_keep_coming_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_a__event_survive_keep_coming_a_01",
			"loc_ogryn_a__event_survive_keep_coming_a_02",
			"loc_ogryn_a__event_survive_keep_coming_a_03",
			"loc_ogryn_a__event_survive_keep_coming_a_04"
		},
		sound_events_duration = {
			3.252615,
			1.063313,
			1.901052,
			2.662208
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_survive_ogryn_a", event_vo_survive_ogryn_a)
