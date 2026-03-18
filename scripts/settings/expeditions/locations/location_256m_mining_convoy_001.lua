-- chunkname: @scripts/settings/expeditions/locations/location_256m_mining_convoy_001.lua

return {
	level_name = "content/levels/expeditions/locations/wastes/location_256m_mining_convoy_001/missions/mission_loc_256m_mining_convoy_001",
	entrances = {
		"entrance_01",
		"entrance_02",
	},
	exits = {
		"exit_01",
		"exit_02",
		"exit_03",
		"exit_04",
	},
	allowed_exits_by_entrances = {
		entrance_01 = {
			"exit_02",
			"exit_03",
			"exit_04",
		},
		entrance_02 = {
			"exit_01",
			"exit_02",
			"exit_04",
		},
	},
	allowed_arrivals_by_exits = {
		exit_01 = {
			"arrival_01",
		},
		exit_02 = {
			"arrival_01",
		},
		exit_03 = {
			"arrival_01",
		},
		exit_04 = {
			"arrival_01",
		},
	},
}
