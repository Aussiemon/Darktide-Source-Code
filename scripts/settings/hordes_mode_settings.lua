-- chunkname: @scripts/settings/hordes_mode_settings.lua

local hordes_mode_settings = {
	num_family_buffs_per_island = 7,
	num_legendary_buffs_per_island = 3,
	waves_per_island = 12,
	island_names = {
		"island_void",
		"island_rooftops",
	},
	give_legendary_buffs_at_waves = {
		3,
		6,
		9,
	},
	give_family_buffs_at_waves = {
		1,
		2,
		4,
		5,
		7,
		8,
		10,
	},
	mission_objectives = {
		wave_objective = {
			name = "objective_psykhanium_void_wave",
		},
		between_waves_objective = {
			name = "objective_psykhanium_void_inbetween_wave",
		},
		name_formating_function = function (objective_name, wave_num)
			return string.format("%s_%d", objective_name, wave_num)
		end,
	},
	post_wave_pause_duration = {
		20,
		30,
		30,
		20,
		30,
		30,
		20,
		30,
		30,
		20,
		20,
		20,
	},
}

return settings("hordes_mode_settings", hordes_mode_settings)
