-- chunkname: @dialogues/generated/event_vo_demolition_psyker_female_a.lua

local event_vo_demolition_psyker_female_a = {
	event_demolition_first_corruptor_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_a__event_demolition_first_corruptor_destroyed_a_01",
			"loc_psyker_female_a__event_demolition_first_corruptor_destroyed_a_02",
			"loc_psyker_female_a__event_demolition_first_corruptor_destroyed_a_03",
			"loc_psyker_female_a__event_demolition_first_corruptor_destroyed_a_04"
		},
		sound_events_duration = {
			3.090625,
			4.793563,
			2.254083,
			2.303625
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_demolition_psyker_female_a", event_vo_demolition_psyker_female_a)
