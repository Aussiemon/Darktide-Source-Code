-- chunkname: @dialogues/generated/enemy_vo_captain_twin_female_a.lua

local enemy_vo_captain_twin_female_a = {
	twin_spawn_laugh_a = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_captain_twin_female_a__laugh_a_01",
			"loc_captain_twin_female_a__laugh_a_02",
			"loc_captain_twin_female_a__laugh_a_03",
			"loc_captain_twin_female_a__laugh_a_04",
			"loc_captain_twin_female_a__laugh_a_05",
		},
		sound_events_duration = {
			1.007521,
			1.084438,
			1.328292,
			1.878708,
			1.517958,
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2,
		},
		randomize_indexes = {},
	},
}

return settings("enemy_vo_captain_twin_female_a", enemy_vo_captain_twin_female_a)
