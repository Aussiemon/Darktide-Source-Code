-- chunkname: @dialogues/generated/event_vo_hacking_broker_female_b.lua

local event_vo_hacking_broker_female_b = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_b__hacking_auspex_mutter_a_01",
			[2] = "loc_broker_female_b__hacking_auspex_mutter_a_02",
		},
		sound_events_duration = {
			[1] = 1.751344,
			[2] = 1.544,
		},
		randomize_indexes = {},
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_b__response_to_hacking_fix_decode_01",
			[2] = "loc_broker_female_b__response_to_hacking_fix_decode_02",
		},
		sound_events_duration = {
			[1] = 1.726604,
			[2] = 1.701948,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_hacking_broker_female_b", event_vo_hacking_broker_female_b)
