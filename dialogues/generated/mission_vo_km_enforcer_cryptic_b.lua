-- chunkname: @dialogues/generated/mission_vo_km_enforcer_cryptic_b.lua

local mission_vo_km_enforcer_cryptic_b = {
	mission_enforcer_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_cryptic_b__guidance_starting_area_01",
			"loc_cryptic_b__guidance_starting_area_02",
			"loc_cryptic_b__guidance_starting_area_03",
			"loc_cryptic_b__guidance_starting_area_04",
			"loc_cryptic_b__guidance_starting_area_05",
		},
		sound_events_duration = {
			3.329385,
			4.440385,
			3.256146,
			3.062646,
			4.296688,
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

return settings("mission_vo_km_enforcer_cryptic_b", mission_vo_km_enforcer_cryptic_b)
