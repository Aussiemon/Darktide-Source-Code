local DEFAULT_TRAVEL_DISTANCE_THRESHOLD = 40
local respawn_beacon_guard_settings = {
	{
		position_offset_range = 1.25,
		direction_degree_range = 180,
		num_guards = 2,
		side_id = 2,
		breeds = {
			cultists = {
				"cultist_melee",
				"cultist_assault"
			},
			traitor_guards = {
				"renegade_melee",
				"renegade_rifleman"
			}
		},
		travel_distance_threshold = DEFAULT_TRAVEL_DISTANCE_THRESHOLD
	},
	{
		position_offset_range = 1.25,
		direction_degree_range = 180,
		num_guards = 2,
		side_id = 2,
		breeds = {
			cultists = {
				"cultist_melee",
				"cultist_assault"
			},
			traitor_guards = {
				"renegade_melee",
				"renegade_rifleman"
			}
		},
		travel_distance_threshold = DEFAULT_TRAVEL_DISTANCE_THRESHOLD
	},
	{
		position_offset_range = 1.25,
		direction_degree_range = 180,
		num_guards = 3,
		side_id = 2,
		breeds = {
			cultists = {
				"cultist_melee",
				"cultist_assault",
				"cultist_berzerker",
				"cultist_gunner"
			},
			traitor_guards = {
				"renegade_melee",
				"renegade_rifleman",
				"renegade_executor",
				"renegade_gunner"
			}
		},
		travel_distance_threshold = DEFAULT_TRAVEL_DISTANCE_THRESHOLD
	},
	{
		position_offset_range = 1.25,
		direction_degree_range = 180,
		num_guards = 3,
		side_id = 2,
		breeds = {
			cultists = {
				"cultist_berzerker",
				"cultist_gunner"
			},
			traitor_guards = {
				"renegade_rifleman",
				"renegade_executor",
				"renegade_gunner"
			}
		},
		travel_distance_threshold = DEFAULT_TRAVEL_DISTANCE_THRESHOLD
	},
	{
		position_offset_range = 1.75,
		direction_degree_range = 180,
		num_guards = 3,
		side_id = 2,
		breeds = {
			cultists = {
				"cultist_assault",
				"cultist_gunner",
				"chaos_ogryn_bulwark",
				"cultist_berzerker",
				"chaos_ogryn_gunner"
			},
			traitor_guards = {
				"renegade_rifleman",
				"renegade_gunner",
				"chaos_ogryn_bulwark",
				"renegade_executor",
				"renegade_executor"
			}
		},
		travel_distance_threshold = DEFAULT_TRAVEL_DISTANCE_THRESHOLD
	}
}

return settings("RespawnBeaconGuardSettings", respawn_beacon_guard_settings)
