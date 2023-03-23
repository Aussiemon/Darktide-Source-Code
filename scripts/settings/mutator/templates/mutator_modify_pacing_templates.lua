local RoamerPacks = require("scripts/settings/roamer/roamer_packs")
local mutator_templates = {
	mutator_more_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			max_alive_specials_multiplier = 2,
			specials_timer_modifier = 0.25
		}
	},
	mutator_waves_of_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			max_alive_specials_multiplier = 2,
			chance_of_coordinated_strike = 1,
			specials_timer_modifier = 0.85,
			max_of_same_override = {
				cultist_mutant = 6,
				chaos_hound = 4,
				renegade_grenadier = 4,
				chaos_poxwalker_bomber = 4,
				renegade_netgunner = 3,
				renegade_sniper = 5,
				renegade_flamer = 3,
				cultist_flamer = 3
			}
		}
	},
	mutator_more_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			horde_timer_modifier = 0.1,
			required_horde_travel_distance = 1
		}
	},
	mutator_more_monsters = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			monsters_per_travel_distance = 120,
			monster_spawn_type = "monsters",
			monster_breed_name = {
				"chaos_plague_ogryn"
			}
		}
	},
	mutator_more_witches = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		modify_pacing = {
			monster_spawn_type = "witches",
			monsters_per_travel_distance = {
				90,
				160
			},
			monster_breed_name = {
				"chaos_daemonhost"
			}
		}
	},
	mutator_more_encampments = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			encampments_override_chance = 0.3,
			num_encampments_override = 6
		}
	},
	mutator_add_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			modify_resistance = 1
		}
	},
	mutator_subtract_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			modify_resistance = -1
		}
	},
	mutator_darkness_los = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing"
	},
	mutator_ventilation_purge_los = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing"
	},
	mutator_travel_distance_spawning_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing"
	},
	mutator_travel_distance_spawning_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing"
	},
	mutator_set_min_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			set_resistance = 1
		}
	},
	mutator_set_max_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			set_resistance = 5
		}
	},
	mutator_set_min_challenge = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			set_challenge = 1
		}
	},
	mutator_set_max_challenge = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			set_challenge = 6
		}
	},
	mutator_no_encampments = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			encampments_override_chance = 0,
			num_encampments_override = 0
		}
	},
	mutator_only_none_roamer_packs = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_all_roamer_packs = {
				renegade = RoamerPacks.renegade_traitor_mix_none,
				cultist = RoamerPacks.cultist_infected_mix_none
			}
		}
	},
	mutator_low_roamer_amount = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_num_roamer_range = {
				1,
				2
			}
		}
	},
	mutator_no_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			horde_timer_modifier = 99999
		}
	},
	mutator_renegade_flamer_none_packs = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_roamer_packs = {
				none = {
					renegade = RoamerPacks.renegade_flamers_mutator,
					cultist = RoamerPacks.renegade_flamers_mutator
				}
			}
		}
	},
	mutator_only_traitor_guard_faction = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		init_modify_pacing = {
			override_faction = "renegade"
		}
	},
	mutator_toxic_gas = {
		class = "scripts/managers/mutator/mutators/mutator_toxic_gas",
		gas_settings = {
			num_gas_clouds = 10
		}
	}
}

return mutator_templates
