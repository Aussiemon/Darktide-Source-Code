-- chunkname: @dialogues/generated/event_vo_survive_ogryn_c.lua

local event_vo_survive_ogryn_c = {
	event_survive_almost_done = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__event_survive_almost_done_01",
			"loc_ogryn_c__event_survive_almost_done_02",
			"loc_ogryn_c__event_survive_almost_done_03",
			"loc_ogryn_c__event_survive_almost_done_04"
		},
		sound_events_duration = {
			1.588365,
			2.627323,
			2.523708,
			1.358417
		},
		randomize_indexes = {}
	},
	event_survive_keep_coming_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__event_survive_keep_coming_a_01",
			"loc_ogryn_c__event_survive_keep_coming_a_02",
			"loc_ogryn_c__event_survive_keep_coming_a_03",
			"loc_ogryn_c__event_survive_keep_coming_a_04"
		},
		sound_events_duration = {
			1.462698,
			1.850979,
			2.412104,
			2.221906
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_survive_ogryn_c", event_vo_survive_ogryn_c)
