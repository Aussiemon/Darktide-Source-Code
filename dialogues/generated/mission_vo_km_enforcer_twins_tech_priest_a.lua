local mission_vo_km_enforcer_twins_tech_priest_a = {
	mission_enforcer_twins_maintenance_area = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__mission_enforcer_maintenance_area_01",
			"loc_tech_priest_a__mission_enforcer_maintenance_area_02",
			"loc_tech_priest_a__mission_enforcer_maintenance_area_03",
			"loc_tech_priest_a__mission_enforcer_maintenance_area_04"
		},
		sound_events_duration = {
			8.503667,
			8.80875,
			7.151146,
			6.050125
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_km_enforcer_twins_tech_priest_a", mission_vo_km_enforcer_twins_tech_priest_a)
