-- chunkname: @dialogues/generated/mission_vo_op_train_cargo_pilot_a.lua

local mission_vo_op_train_cargo_pilot_a = {
	mission_train_boss_arrival_foreshadow_a = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_cargo_pilot_a__mission_train_boss_arrival_foreshadow_a_01",
			"loc_cargo_pilot_a__mission_train_boss_arrival_foreshadow_a_02",
			"loc_cargo_pilot_a__mission_train_boss_arrival_foreshadow_a_03",
		},
		sound_events_duration = {
			3.6095,
			3.801708,
			3.269625,
		},
		randomize_indexes = {},
	},
	mission_train_fifth_objective_complete_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_cargo_pilot_a__mission_train_fifth_objective_complete_b_01",
			"loc_cargo_pilot_a__mission_train_fifth_objective_complete_b_02",
			"loc_cargo_pilot_a__mission_train_fifth_objective_complete_b_03",
		},
		sound_events_duration = {
			1.502813,
			1.669208,
			1.753104,
		},
		randomize_indexes = {},
	},
	mission_train_second_interstitial_01_c = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_cargo_pilot_a__mission_train_second_interstitial_01_c_01",
		},
		sound_events_duration = {
			[1] = 5.364813,
		},
		randomize_indexes = {},
	},
	mission_train_second_interstitial_02_c = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_cargo_pilot_a__mission_train_second_interstitial_02_c_01",
		},
		sound_events_duration = {
			[1] = 5.761625,
		},
		randomize_indexes = {},
	},
	mission_train_second_interstitial_03_c = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_cargo_pilot_a__mission_train_second_interstitial_03_c_01",
		},
		sound_events_duration = {
			[1] = 4.106167,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_op_train_cargo_pilot_a", mission_vo_op_train_cargo_pilot_a)
