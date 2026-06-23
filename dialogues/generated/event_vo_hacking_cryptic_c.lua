-- chunkname: @dialogues/generated/event_vo_hacking_cryptic_c.lua

local event_vo_hacking_cryptic_c = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_c__hacking_auspex_mutter_a_01",
			[2] = "loc_cryptic_c__hacking_auspex_mutter_a_02",
		},
		sound_events_duration = {
			[1] = 1.863625,
			[2] = 2.258896,
		},
		randomize_indexes = {},
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_c__response_to_hacking_fix_decode_01",
			[2] = "loc_cryptic_c__response_to_hacking_fix_decode_02",
		},
		sound_events_duration = {
			[1] = 1.615219,
			[2] = 2.25225,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_hacking_cryptic_c", event_vo_hacking_cryptic_c)
