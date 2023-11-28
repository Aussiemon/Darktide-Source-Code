-- chunkname: @dialogues/generated/mission_vo_fm_armoury_ogryn_b.lua

local mission_vo_fm_armoury_ogryn_b = {
	mission_armoury_side_streets_c_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_ogryn_b__region_carnival_a_01",
			"loc_ogryn_b__region_carnival_a_02",
			"loc_ogryn_b__region_carnival_a_03"
		},
		sound_events_duration = {
			4.459042,
			2.33175,
			2.5395
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_fm_armoury_ogryn_b", mission_vo_fm_armoury_ogryn_b)
