-- chunkname: @dialogues/generated/event_vo_hacking_broker_female_c.lua

local event_vo_hacking_broker_female_c = {
	hacking_auspex_mutter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_c__hacking_auspex_mutter_a_01",
			[2] = "loc_broker_female_c__hacking_auspex_mutter_a_02",
		},
		sound_events_duration = {
			[1] = 2.572271,
			[2] = 3.756854,
		},
		randomize_indexes = {},
	},
	response_to_hacking_fix_decode = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_c__response_to_hacking_fix_decode_01",
			[2] = "loc_broker_female_c__response_to_hacking_fix_decode_02",
		},
		sound_events_duration = {
			[1] = 2.448396,
			[2] = 1.929885,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_hacking_broker_female_c", event_vo_hacking_broker_female_c)
