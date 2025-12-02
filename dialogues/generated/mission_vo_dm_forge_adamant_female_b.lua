-- chunkname: @dialogues/generated/mission_vo_dm_forge_adamant_female_b.lua

local mission_vo_dm_forge_adamant_female_b = {
	event_demolition_first_corruptor_destroyed_a_enginseer = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_b__event_demolition_first_corruptor_destroyed_a_01",
			"loc_adamant_female_b__event_demolition_first_corruptor_destroyed_a_02",
			"loc_adamant_female_b__event_demolition_first_corruptor_destroyed_a_03",
			"loc_adamant_female_b__event_demolition_first_corruptor_destroyed_a_04",
		},
		sound_events_duration = {
			1.7175,
			1.787094,
			3.707542,
			2.733344,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
	mission_forge_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_female_b__guidance_starting_area_01",
			"loc_adamant_female_b__guidance_starting_area_02",
			"loc_adamant_female_b__guidance_starting_area_03",
			"loc_adamant_female_b__guidance_starting_area_04",
			"loc_adamant_female_b__guidance_starting_area_05",
			"loc_adamant_female_b__guidance_starting_area_06",
			"loc_adamant_female_b__guidance_starting_area_07",
			"loc_adamant_female_b__guidance_starting_area_08",
		},
		sound_events_duration = {
			2.489438,
			2.14924,
			3.805177,
			3.799354,
			4.19201,
			3.705521,
			2.911885,
			3.076052,
		},
		sound_event_weights = {
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
		},
		randomize_indexes = {},
	},
	mission_forge_main_entrance_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_b__region_mechanicus_01",
			"loc_adamant_female_b__region_mechanicus_02",
			"loc_adamant_female_b__region_mechanicus_03",
		},
		sound_events_duration = {
			3.973344,
			3.64401,
			5.014677,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_forge_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_b__mission_forge_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 4.095583,
		},
		randomize_indexes = {},
	},
	mission_forge_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_b__zone_tank_foundry_01",
			"loc_adamant_female_b__zone_tank_foundry_02",
			"loc_adamant_female_b__zone_tank_foundry_03",
		},
		sound_events_duration = {
			2.308677,
			4.278,
			4.40001,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_forge_strategic_asset = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_b__mission_forge_strategic_asset_01",
		},
		sound_events_duration = {
			[1] = 5.878292,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_forge_adamant_female_b", mission_vo_dm_forge_adamant_female_b)
