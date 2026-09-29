-- chunkname: @dialogues/generated/event_vo_demolition_ogryn_c.lua

local event_vo_demolition_ogryn_c = {
	event_demolition_first_corruptor_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__event_demolition_first_corruptor_destroyed_a_01",
			"loc_ogryn_c__event_demolition_first_corruptor_destroyed_a_02",
			"loc_ogryn_c__event_demolition_first_corruptor_destroyed_a_03",
			"loc_ogryn_c__event_demolition_first_corruptor_destroyed_a_04"
		},
		sound_events_duration = {
			3.975531,
			2.595833,
			1.766031,
			2.07475
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_demolition_ogryn_c", event_vo_demolition_ogryn_c)
