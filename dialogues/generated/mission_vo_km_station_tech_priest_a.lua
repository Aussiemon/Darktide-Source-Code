local mission_vo_km_station_tech_priest_a = {
	mission_station_vox_introduction_tech_priest = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_tech_priest_a__vox_introduction_tech_priest_01",
			"loc_tech_priest_a__vox_introduction_tech_priest_02",
			"loc_tech_priest_a__vox_introduction_tech_priest_03",
			"loc_tech_priest_a__vox_introduction_tech_priest_04",
			"loc_tech_priest_a__vox_introduction_tech_priest_05"
		},
		sound_events_duration = {
			3.679,
			1.81098,
			1.808667,
			3.066813,
			1.485375
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_km_station_tech_priest_a", mission_vo_km_station_tech_priest_a)
