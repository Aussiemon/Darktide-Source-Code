-- chunkname: @dialogues/generated/event_vo_hacking_broker_male_a.lua

local event_vo_hacking_broker_male_a = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_a__hacking_auspex_mutter_a_01",
			[2] = "loc_broker_male_a__hacking_auspex_mutter_a_02",
		},
		sound_events_duration = {
			[1] = 1.16301,
			[2] = 1.602667,
		},
		randomize_indexes = {},
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_a__response_to_hacking_fix_decode_01",
			[2] = "loc_broker_male_a__response_to_hacking_fix_decode_02",
		},
		sound_events_duration = {
			[1] = 2.206083,
			[2] = 1.603333,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_hacking_broker_male_a", event_vo_hacking_broker_male_a)
