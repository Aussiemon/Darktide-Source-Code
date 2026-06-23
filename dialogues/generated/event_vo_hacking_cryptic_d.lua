-- chunkname: @dialogues/generated/event_vo_hacking_cryptic_d.lua

local event_vo_hacking_cryptic_d = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_d__hacking_auspex_mutter_a_01",
			[2] = "loc_cryptic_d__hacking_auspex_mutter_a_02",
		},
		sound_events_duration = {
			[1] = 2.762146,
			[2] = 1.530083,
		},
		randomize_indexes = {},
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_d__response_to_hacking_fix_decode_01",
			[2] = "loc_cryptic_d__response_to_hacking_fix_decode_02",
		},
		sound_events_duration = {
			[1] = 3.61099,
			[2] = 3.418521,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_hacking_cryptic_d", event_vo_hacking_cryptic_d)
