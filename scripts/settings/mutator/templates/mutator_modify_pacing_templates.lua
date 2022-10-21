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
			specials_timer_modifier = 0.4
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
			horde_timer_modifier = 0.35,
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
			monsters_per_travel_distance = 80,
			monster_spawn_type = "witches",
			monster_breed_name = "chaos_daemonhost"
		}
	}
}

return mutator_templates
