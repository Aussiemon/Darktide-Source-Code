-- chunkname: @dialogues/generated/mission_vo_km_station_cryptic_d.lua

local mission_vo_km_station_cryptic_d = {
	info_mission_station_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_cryptic_d__guidance_starting_area_01",
			"loc_cryptic_d__guidance_starting_area_02",
			"loc_cryptic_d__guidance_starting_area_03",
			"loc_cryptic_d__guidance_starting_area_04",
			"loc_cryptic_d__guidance_starting_area_05",
		},
		sound_events_duration = {
			4.341792,
			4.656667,
			4.577969,
			5.421229,
			3.888615,
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

return settings("mission_vo_km_station_cryptic_d", mission_vo_km_station_cryptic_d)
