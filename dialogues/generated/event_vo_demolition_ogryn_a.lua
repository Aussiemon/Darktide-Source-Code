-- chunkname: @dialogues/generated/event_vo_demolition_ogryn_a.lua

local event_vo_demolition_ogryn_a = {
	event_demolition_first_corruptor_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_a__event_demolition_first_corruptor_destroyed_a_01",
			"loc_ogryn_a__event_demolition_first_corruptor_destroyed_a_02",
			"loc_ogryn_a__event_demolition_first_corruptor_destroyed_a_03",
			"loc_ogryn_a__event_demolition_first_corruptor_destroyed_a_04"
		},
		sound_events_duration = {
			2.593969,
			2.837719,
			1.866479,
			1.95125
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_demolition_ogryn_a", event_vo_demolition_ogryn_a)
