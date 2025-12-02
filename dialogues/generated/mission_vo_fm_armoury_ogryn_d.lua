-- chunkname: @dialogues/generated/mission_vo_fm_armoury_ogryn_d.lua

local mission_vo_fm_armoury_ogryn_d = {
	mission_armoury_side_streets_c_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_ogryn_d__region_carnival_a_01",
			"loc_ogryn_d__region_carnival_a_02",
			"loc_ogryn_d__region_carnival_a_03",
		},
		sound_events_duration = {
			3.762385,
			3.227917,
			7.033552,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_fm_armoury_ogryn_d", mission_vo_fm_armoury_ogryn_d)
