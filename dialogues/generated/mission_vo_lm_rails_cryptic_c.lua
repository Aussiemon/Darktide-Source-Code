-- chunkname: @dialogues/generated/mission_vo_lm_rails_cryptic_c.lua

local mission_vo_lm_rails_cryptic_c = {
	mission_rails_disable_skyfire_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_cryptic_c__mission_rails_disable_skyfire_a_01",
		},
		sound_events_duration = {
			[1] = 3.403802,
		},
		randomize_indexes = {},
	},
	mission_rails_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_cryptic_c__guidance_starting_area_01",
			"loc_cryptic_c__guidance_starting_area_02",
			"loc_cryptic_c__guidance_starting_area_03",
			"loc_cryptic_c__guidance_starting_area_04",
			"loc_cryptic_c__guidance_starting_area_05",
		},
		sound_events_duration = {
			3.623542,
			3.451458,
			2.55001,
			3.043302,
			5.726906,
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

return settings("mission_vo_lm_rails_cryptic_c", mission_vo_lm_rails_cryptic_c)
