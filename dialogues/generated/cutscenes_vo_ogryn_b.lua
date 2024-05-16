-- chunkname: @dialogues/generated/cutscenes_vo_ogryn_b.lua

local cutscenes_vo_ogryn_b = {
	cs_prologue_five_05 = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_ogryn_b__cs_prologue_five_05_01",
		},
		sound_events_duration = {
			[1] = 1.666646,
		},
		randomize_indexes = {},
	},
	cs_prologue_three_04 = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_ogryn_b__cs_prologue_three_04_01",
		},
		sound_events_duration = {
			[1] = 0.666646,
		},
		randomize_indexes = {},
	},
	cs_prologue_two_16 = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_ogryn_b__cs_prologue_two_16_01",
		},
		sound_events_duration = {
			[1] = 3.460333,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
}

return settings("cutscenes_vo_ogryn_b", cutscenes_vo_ogryn_b)
