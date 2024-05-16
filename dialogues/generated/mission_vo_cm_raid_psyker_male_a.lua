-- chunkname: @dialogues/generated/mission_vo_cm_raid_psyker_male_a.lua

local mission_vo_cm_raid_psyker_male_a = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_male_a__guidance_starting_area_01",
			"loc_psyker_male_a__guidance_starting_area_02",
			"loc_psyker_male_a__guidance_starting_area_03",
			"loc_psyker_male_a__guidance_starting_area_04",
			"loc_psyker_male_a__guidance_starting_area_05",
			"loc_psyker_male_a__guidance_starting_area_06",
			"loc_psyker_male_a__guidance_starting_area_07",
			"loc_psyker_male_a__guidance_starting_area_08",
			"loc_psyker_male_a__guidance_starting_area_09",
			"loc_psyker_male_a__guidance_starting_area_10",
		},
		sound_events_duration = {
			4.460938,
			6.092438,
			2.789938,
			4.628729,
			6.292563,
			3.399583,
			5.082125,
			5.392583,
			3.9875,
			4.166396,
		},
		sound_event_weights = {
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
		},
		randomize_indexes = {},
	},
	mission_raid_region_carnival = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_male_a__region_carnival_a_01",
			"loc_psyker_male_a__region_carnival_a_02",
			"loc_psyker_male_a__region_carnival_a_03",
		},
		sound_events_duration = {
			5.823479,
			5.122646,
			7.899896,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_a__mission_raid_trapped_a_01",
			"loc_psyker_male_a__mission_raid_trapped_a_02",
			"loc_psyker_male_a__mission_raid_trapped_a_03",
			"loc_psyker_male_a__mission_raid_trapped_a_04",
		},
		sound_events_duration = {
			1.509438,
			2.058417,
			2.460458,
			3.326354,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_a__mission_raid_trapped_b_01",
			"loc_psyker_male_a__mission_raid_trapped_b_02",
			"loc_psyker_male_a__mission_raid_trapped_b_03",
			"loc_psyker_male_a__mission_raid_trapped_b_04",
		},
		sound_events_duration = {
			4.264083,
			4.460688,
			4.240813,
			4.434979,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_a__mission_raid_trapped_c_01",
			"loc_psyker_male_a__mission_raid_trapped_c_02",
			"loc_psyker_male_a__mission_raid_trapped_c_03",
			"loc_psyker_male_a__mission_raid_trapped_c_04",
		},
		sound_events_duration = {
			3.112292,
			5.375771,
			2.964938,
			4.107646,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_psyker_male_a", mission_vo_cm_raid_psyker_male_a)
