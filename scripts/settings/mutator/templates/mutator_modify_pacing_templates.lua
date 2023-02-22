local mutator_templates = {
	mutator_more_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		description = {
			"loc_mutator_minion_nurgle_blessing_description_1",
			"loc_mutator_minion_nurgle_blessing_description_2",
			"loc_mutator_minion_nurgle_blessing_description_3"
		},
		modify_pacing = {
			max_alive_specials_multiplier = 1.5,
			specials_timer_modifier = 0.5
		}
	},
	mutator_more_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		description = {
			"loc_mutator_minion_nurgle_blessing_description_1",
			"loc_mutator_minion_nurgle_blessing_description_2",
			"loc_mutator_minion_nurgle_blessing_description_3"
		},
		modify_pacing = {
			horde_timer_modifier = 0.1,
			required_horde_travel_distance = 1
		}
	},
	mutator_more_monsters = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		description = {
			"loc_mutator_minion_nurgle_blessing_description_1",
			"loc_mutator_minion_nurgle_blessing_description_2",
			"loc_mutator_minion_nurgle_blessing_description_3"
		},
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
		description = {
			"loc_mutator_minion_nurgle_blessing_description_1",
			"loc_mutator_minion_nurgle_blessing_description_2",
			"loc_mutator_minion_nurgle_blessing_description_3"
		},
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
		description = {
			"loc_mutator_minion_nurgle_blessing_description_1",
			"loc_mutator_minion_nurgle_blessing_description_2",
			"loc_mutator_minion_nurgle_blessing_description_3"
		},
		init_modify_pacing = {
			encampments_override_chance = 0.3,
			num_encampments_override = 6
		}
	},
	mutator_add_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		description = {
			"loc_mutator_minion_nurgle_blessing_description_1",
			"loc_mutator_minion_nurgle_blessing_description_2",
			"loc_mutator_minion_nurgle_blessing_description_3"
		},
		init_modify_pacing = {
			modify_resistance = 1
		}
	},
	mutator_subtract_resistance = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		description = {
			"loc_mutator_minion_nurgle_blessing_description_1",
			"loc_mutator_minion_nurgle_blessing_description_2",
			"loc_mutator_minion_nurgle_blessing_description_3"
		},
		init_modify_pacing = {
			modify_resistance = -1
		}
	},
	mutator_travel_distance_spawning_specials = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		description = {
			"loc_mutator_minion_nurgle_blessing_description_1",
			"loc_mutator_minion_nurgle_blessing_description_2",
			"loc_mutator_minion_nurgle_blessing_description_3"
		}
	},
	mutator_travel_distance_spawning_hordes = {
		class = "scripts/managers/mutator/mutators/mutator_modify_pacing",
		description = {
			"loc_mutator_minion_nurgle_blessing_description_1",
			"loc_mutator_minion_nurgle_blessing_description_2",
			"loc_mutator_minion_nurgle_blessing_description_3"
		}
	}
}

return mutator_templates
