local cutscenes_vo_psyker_male_c = {
	cs_prologue_five_05 = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_psyker_male_c__cs_prologue_five_05_01"
		},
		sound_events_duration = {
			[1.0] = 1.799938
		},
		randomize_indexes = {}
	},
	cs_prologue_three_04 = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_psyker_male_c__cs_prologue_three_04_01"
		},
		sound_events_duration = {
			[1.0] = 0.927979
		},
		randomize_indexes = {}
	},
	cs_prologue_two_16 = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1.0] = "loc_psyker_male_c__cs_prologue_two_16_01"
		},
		sound_events_duration = {
			[1.0] = 4.866646
		},
		sound_event_weights = {
			[1.0] = 1
		},
		randomize_indexes = {}
	}
}

return settings("cutscenes_vo_psyker_male_c", cutscenes_vo_psyker_male_c)
